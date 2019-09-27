//
//  MyConstructionSiteViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MyConstructionSiteViewController.h"
#import "ConstructionDiaryViewController.h"
#import "SiteTableViewCell.h"
#import "GetAllConstructionsApi.h"
#import "FinishSiteApi.h"
#import "MySiteModel.h"
#import "SiteModel.h"
#import "MainMaterialDiaryController.h"
#import "ZCHConstructionCommentController.h"
#import "ZCHConstructionVipController.h"
#import "ClickTextView.h"
#import "ManagerViewController.h"
#import "LoginViewController.h"
#import "CreateConstructionViewController.h"
#import "SSPopup.h"
#import "CreateCompanyViewController.h"
#import "JoinCompanyController.h"
#import "CreatShopController.h"
#import "NSObject+CompressImage.h"
#import "ConstructionDiaryTwoController.h"
#import "VipGroupViewController.h"
#import "selectlogtypeVC.h"

typedef NS_ENUM(NSUInteger, SegmentSelectedType) {
    SegmentSelectedTypeNotCompletion = 0, // 未交工
    SegmentSelectedTypeAllSite, // 全部工地
};

@interface MyConstructionSiteViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,SiteTableViewCellDelegate,UIAlertViewDelegate,SSPopupDelegate>
{
    MySiteModel *mySelectModel;
    NSInteger _allSitePageNum;
    NSInteger _notCompletionPageNum; // 未交工页数
    NSInteger _companyId;
    BOOL isAeraNameNoexit;//是否提示小区名称不存在
}
@property (nonatomic, strong)IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UITableView *siteTableView;
@property (nonatomic, strong) NSMutableArray *siteArray; // 全部工地”是原来的“我的工地页面”
@property (nonatomic, strong) NSMutableArray *notCompletionSiteArray;
// 底部的推送菜单
@property (strong, nonatomic) UIView *bottomSendView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, assign) SegmentSelectedType segmentSelectType;
@end

@implementation MyConstructionSiteViewController

-(NSMutableArray*)siteArray{
    
    if (!_siteArray) {
        _siteArray = [NSMutableArray array];
    }
    return _siteArray;
}

- (NSMutableArray *)notCompletionSiteArray {
    if (!_notCompletionSiteArray) {
        _notCompletionSiteArray = [NSMutableArray array];
    }
    return _notCompletionSiteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [self createTableView];
    [self addBottomSendView];
    _segmentSelectType = SegmentSelectedTypeNotCompletion;

    self.siteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _allSitePageNum = 1;
        _notCompletionPageNum = 1;
        if (_segmentSelectType == SegmentSelectedTypeAllSite) {
            [self getSiteListArray];
        } else {
            [self getNotCompeltionSiteList];
        }
    }];
    self.siteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _allSitePageNum += 1;
        _notCompletionPageNum += 1;
        if (_segmentSelectType == SegmentSelectedTypeAllSite) {
            [self getSiteListArray];
        } else {
            [self getNotCompeltionSiteList];
        }
    }];
    [self.siteTableView.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [NSObject promptWithControllerName:@"MyConstructionSiteViewController"];
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
        ClickTextView *_clickTextView = nil;
        _clickTextView = [[ClickTextView alloc] initWithFrame:CGRectZero];
        [self.footerView addSubview:_clickTextView];
        [_clickTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.centerX.equalTo(0);
            make.height.equalTo(30);
        }];
        _clickTextView.font = [UIFont systemFontOfSize:14];
        _clickTextView.textColor = [UIColor lightGrayColor];
        _clickTextView.textAlignment = NSTextAlignmentCenter;
        _clickTextView.backgroundColor = [UIColor clearColor];
        
        NSString *content = @"还没有新工地？去新建工地吧";
        // 设置文字
        _clickTextView.text = content;
        
        // 设置期中的一段文字有下划线，下划线的颜色为蓝色，点击下划线文字有相关的点击效果
        NSRange range1 = [content rangeOfString:@"新建工地"];
        MJWeakSelf;
        [_clickTextView setUnderlineTextWithRange:range1 withUnderlineColor:[UIColor blueColor] withClickCoverColor:[UIColor clearColor] withBlock:^(NSString *clickText) {
           BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
            //是否登录
            if (!isLogin) {
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.tag = 300;
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            [self getUserLimit];
            
        }];
    }
    return _footerView;
}

#pragma mark - 新建工地
-(void)getUserLimit{
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/newGdQx.do"];
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        YSNLog(@"%@",responseObj);
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    NSArray *companyArray = responseObj[@"companyList"];
                    if (companyArray.count<=0) {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"您还没有创建分公司,请去创建分公司" controller:self sleep:1.5];
                        return ;
                    }
                    if (companyArray.count<=1) {
                        NSDictionary *dict = companyArray[0];
                        
                        if ([dict[@"times"] integerValue] <= 0) {
                            
                            // 不是会员或会员到期  并且 工地数大于等于20  弹出提示
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还不是云管理会员，是否去开通？" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                // 会员套餐
                                VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                                VC.companyId = [NSString stringWithFormat:@"%ld", [dict[@"companyId"] integerValue]];
                                VC.successBlock = ^() {
                                };
                                [self.navigationController pushViewController:VC animated:YES];
                            }];
                            
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                            }];
                            
                            [alert addAction:sureAction];
                            [alert addAction:cancelAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                        
                        
                        //店铺 
                        selectlogtypeVC *vc = [selectlogtypeVC new];
                        vc.roleTypeId = responseObj[@"roleTypeId"];
                        vc.dict = dict;
                        vc.cityId = self.cityId;
                        vc.countyId = self.countyId;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    
                    else{
                        NSMutableArray *nameArray = [NSMutableArray array];
                        for (NSDictionary *dict in companyArray) {
                            NSString *str = [dict objectForKey:@"companyName"];
                            [nameArray addObject:str];
                        }
                        NSArray *QArray = [nameArray copy];
                        
                        SSPopup* selection=[[SSPopup alloc]init];
                        selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                        
                        selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                        selection.SSPopupDelegate=self;
                        [self.view  addSubview:selection];
                        
                        
                        [selection CreateTableview:QArray withTitle:@"选择公司" setCompletionBlock:^(int tag) {
                            YSNLog(@"%d",tag);
                            
                            NSDictionary *dict = companyArray[tag];
                            /*
                             companyId = 594;
                             companyName = "\U672c\U5c71\U4f20";
                             companyType = 1018;
                             constructionNum = 0;
                             times = 64;
                             */
                            if ([dict[@"times"] integerValue] <= 0) {
                                
                                // 不是会员或会员到期  并且 工地数大于等于20  弹出提示
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还不是云管理会员，是否去开通？" preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"开通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    // 会员套餐
                                    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
                                    VC.companyId = [NSString stringWithFormat:@"%ld", [dict[@"companyId"] integerValue]];
                                    VC.successBlock = ^() {
                                    };
                                    [self.navigationController pushViewController:VC animated:YES];
                                    
                                }];
                                
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    
                                }];
                                
                                [alert addAction:sureAction];
                                [alert addAction:cancelAction];
                                [self presentViewController:alert animated:YES completion:nil];
                            }
                            
                            
                            //公司
                            selectlogtypeVC *vc = [selectlogtypeVC new];
                            vc.roleTypeId = responseObj[@"roleTypeId"];
                            vc.dict = dict;
                            vc.cityId = self.cityId;
                            vc.countyId = self.countyId;
                            [self.navigationController pushViewController:vc animated:YES];

                        }];
                    }
                    
                }
                    break;
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"对不起，您没有新建工地的权限！" controller:self sleep:1.5];
                    //
                    return;
                }
                    break;
                case 1002:
                    
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还不属于任何公司" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *createAction = [UIAlertAction actionWithTitle:@"创建公司" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        CreateCompanyViewController *companyVC = [[CreateCompanyViewController alloc]init];
                        [self.navigationController pushViewController:companyVC animated:YES];
                        
                    }];
                    
                    UIAlertAction *joinAction = [UIAlertAction actionWithTitle:@"加入公司" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        JoinCompanyController *vc = [[JoinCompanyController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alert addAction:createAction];
                    [alert addAction:joinAction];
                    [alert addAction:cancelAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                    break;
                case 1003:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"您还未创建分公司或店铺"
                                                                   delegate:self
                                                          cancelButtonTitle:@"下次再说"
                                                          otherButtonTitles:@"去创建",nil];
                    alert.tag = 200;
                    _companyId = [responseObj[@"companyId"] integerValue];
                    [alert show];
                }
                    break;
                default:
                    break;
            }
            
            
            
            
            
        }
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}




-(void)createUI{
    
    self.title = @"工地管理";
    self.view.backgroundColor = Bottom_Color;
    
    UIBarButtonItem *rightItem = [UIBarButtonItem rightItemWithTitle:@"新工地" target:self action:@selector(getUserLimit)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDefault;
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(5, 68, kSCREEN_WIDTH-5-2-36, 36)];
    
    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(5, self.navigationController.navigationBar.bottom + 4, kSCREEN_WIDTH-5-2-36, 36)];
    self.searchTF.delegate = self;
    self.searchTF.backgroundColor = White_Color;
    self.searchTF.layer.borderColor = Bottom_Color.CGColor;
    self.searchTF.layer.cornerRadius = 5;
    self.searchTF.layer.borderWidth = 1;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF.placeholder = @"请输入小区名称";
    
    [self.view addSubview:self.searchTF];
    
    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:searchBtn];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchTF);
        make.left.equalTo(self.searchTF.mas_right).offset(2);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
    
    
    //交工成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"CompleteContruct" object:nil];
    
    //创建工地
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"CreatContructList" object:nil];
    
    //退出工地
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QuitContructrefreshList) name:@"QuitContructList" object:nil];
    
    
    //修改施工日志的工地信息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"modifyContrctInfo" object:nil];
    
    //修改主材日志的工地信息的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"modifyMatiralInfo" object:nil];
    
    //添加主材日志节点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addMatieralNode" object:nil];
    
    //添加施工日志节点通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"addContructionNode" object:nil];
    
    
    UIView *sView = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.bottom + 44, kSCREEN_WIDTH, 60)];
    [self.view addSubview:sView];
    sView.backgroundColor = [UIColor whiteColor];
    
     NSArray *segmentArray = [NSArray arrayWithObjects:@"未交工",@"全部工地", nil];
    UISegmentedControl *_segmentedC = [[UISegmentedControl alloc]initWithItems:segmentArray];
    [sView addSubview:_segmentedC];
    [_segmentedC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
        make.size.equalTo(CGSizeMake(140, 30));
    }];
    _segmentedC.tintColor = kMainThemeColor;
    _segmentedC.selectedSegmentIndex = 0;
    [_segmentedC addTarget:self action:@selector(segmentedClick:) forControlEvents:UIControlEventValueChanged];
}



-(void)createTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom + 44 + 60, kSCREEN_WIDTH, kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom + 44 + 60)) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(0);
        make.top.equalTo(self.navigationController.navigationBar.bottom + 44 + 60);
        if (IphoneX) {
            make.bottom.equalTo(34);
        } else {
            make.bottom.equalTo(0);
        }
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.layoutMargins = UIEdgeInsetsZero;
    tableView.preservesSuperviewLayoutMargins = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.tableFooterView = self.footerView;
    [tableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:nil] forCellReuseIdentifier:@"SiteTableViewCell"];
    
    self.siteTableView = tableView;
}

- (void)segmentedClick:(UISegmentedControl *)seg {
    self.segmentSelectType = seg.selectedSegmentIndex;
    if (self.segmentSelectType == SegmentSelectedTypeAllSite && self.siteArray.count == 0) {
        [self getSiteListArray];
        return;
    }
    if (self.segmentSelectType == SegmentSelectedTypeNotCompletion && self.notCompletionSiteArray.count == 0) {
        [self getNotCompeltionSiteList];
        return;
    }
    
    [self.siteTableView reloadData];
    self.siteTableView.scrollsToTop = YES;
    
}
#pragma mark - 退出工地

-(void)QuitContructrefreshList{
    [self refreshData];
    [[PublicTool defaultTool] publicToolsHUDStr:@"退出成功" controller:self sleep:2];
}

- (void)addBottomSendView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomSendView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, BLEJWidth * 0.3 + 40)];
    self.bottomSendView.backgroundColor = White_Color;
    [self.shadowView addSubview:self.bottomSendView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, BLEJWidth - 40, 40)];
    titleLabel.text = @"推送到...";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomSendView addSubview:titleLabel];
    
    
    NSArray *imageNames = [NSArray new];
    NSArray *names = [NSArray new];
    
    imageNames = @[@"push_jisuanqi", @"sendYellowPage"];
    names = @[@"计算器", @"企业"];
    
    for (int i = 0; i < names.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * BLEJWidth * 0.3 + (i + 1) * (BLEJWidth * 0.1) / 4, titleLabel.bottom, BLEJWidth * 0.3, BLEJWidth * 0.3)];
        btn.tag = i + 1000;
        [btn addTarget:self action:@selector(didClickSendContentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        [btn setTitle:names[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = btn.imageView.frame.size.width;
        CGFloat imageHeight = btn.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        labelWidth = btn.titleLabel.intrinsicContentSize.width;
        labelHeight = btn.titleLabel.intrinsicContentSize.height;
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
        labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
        btn.titleEdgeInsets = labelEdgeInsets;
        btn.imageEdgeInsets = imageEdgeInsets;
        
        [self.bottomSendView addSubview:btn];
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    return [[UITableViewHeaderFooterView alloc]init];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.segmentSelectType == SegmentSelectedTypeNotCompletion) {
        return self.notCompletionSiteArray.count;
    } else {
        return self.siteArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentSelectType == SegmentSelectedTypeAllSite) {
        MySiteModel *model = self.siteArray[indexPath.row];
        if ([model.positionNumber integerValue] > 0) {
            
            return 165;
        }
        return 135;
    } else {
        return 100;
    }
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.path = indexPath;
    
    if (self.segmentSelectType == SegmentSelectedTypeNotCompletion) {
        cell.houseHoldLabel.font = [UIFont systemFontOfSize:16];
        cell.stateBtn.hidden = YES;
        cell.locationLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8 - 4;
        cell.companyLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8;
        
        if (self.notCompletionSiteArray.count>0) {
            id data = self.notCompletionSiteArray[indexPath.row];
            [cell configData:(SiteModel *)data];
        }
    } else {
        [cell configData:(MySiteModel *)self.siteArray[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentSelectType == SegmentSelectedTypeNotCompletion) {
        SiteModel *site = self.notCompletionSiteArray[indexPath.row];
   
        if ([site.constructionType isEqualToString:@"0"]) {
            ConstructionDiaryTwoController *diaryVC = [[ConstructionDiaryTwoController alloc]init];
            diaryVC.consID = site.siteId;
            diaryVC.companyId = site.companyId;
            diaryVC.agencysJob = self.agencysJob;
            diaryVC.companyFlag = self.companyFlag;
            
            [self.navigationController pushViewController:diaryVC animated:YES];
        }
        else{
            MainMaterialDiaryController *diaryVC = [[MainMaterialDiaryController alloc]init];
            diaryVC.consID = site.siteId;
            diaryVC.companyId = site.companyId;
            diaryVC.agencysJob = self.agencysJob;
            diaryVC.companyFlag = self.companyFlag;
            [self.navigationController pushViewController:diaryVC animated:YES];
        }
        return;
    } else {
        MySiteModel *site = self.siteArray[indexPath.row];
        if (self.segmentSelectType == SegmentSelectedTypeAllSite) {
            site = self.siteArray[indexPath.row];
        } else {
            site = self.notCompletionSiteArray[indexPath.row];
        }
        //NSInteger company = [site.companyType integerValue];
        if ([site.constructionType isEqualToString:@"0"]) {
            ConstructionDiaryTwoController *diaryVC = [[ConstructionDiaryTwoController alloc]init];
            diaryVC.consID = [site.constructionId integerValue];
            diaryVC.companyId = site.companyId;
            diaryVC.agencysJob =self.agencysJob;
            diaryVC.companyFlag = self.companyFlag;
            [self.navigationController pushViewController:diaryVC animated:YES];
        }
else{
            MainMaterialDiaryController *diaryVC = [[MainMaterialDiaryController alloc]init];
            diaryVC.consID = [site.constructionId integerValue];
            diaryVC.companyId = site.companyId;
            diaryVC.agencysJob = self.agencysJob;
            diaryVC.companyFlag = self.companyFlag;
            [self.navigationController pushViewController:diaryVC animated:YES];
        }
    }
    
}

#pragma mark - 这里是开启滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentSelectType == SegmentSelectedTypeAllSite) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    MySiteModel *model = self.siteArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"删除后数据不可恢复，是否确认删除？" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                
                //这个按钮需要处理的代码块
                [weakSelf deleteConstructionWithIndex:indexPath];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }];
    
    
    if ([model.isTop integerValue] == 0) {
        
        UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            //这个按钮需要处理的代码块
            [weakSelf setTopConstructionWithIndex:indexPath];
        }];
        topAction.backgroundColor = [UIColor lightGrayColor];
        if ([model.positionNumber integerValue] > 0) {
    
            return [NSArray arrayWithObjects:deleteAction, topAction, nil];
        } else {
            
            return [NSArray arrayWithObjects:topAction, nil];
        }
    } else {
        
        UITableViewRowAction *cancelTopAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
            //这个按钮需要处理的代码块
            [weakSelf cancelTopConstructionWithIndex:indexPath];
        }];
        cancelTopAction.backgroundColor = [UIColor lightGrayColor];
        if ([model.positionNumber integerValue] > 0) {
            
            return [NSArray arrayWithObjects:deleteAction, cancelTopAction, nil];
        } else {
            
            return [NSArray arrayWithObjects:cancelTopAction, nil];
        }
    }
}

#pragma mark - SiteTableViewCellDelegate
// 未交工的工地 状态按钮事件
-(void)HandleccompleteWith:(NSIndexPath *)path{
    NSInteger row = path.row;
    SiteModel *model = self.notCompletionSiteArray[row];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"确认交工后将不能修改日志，是否确认交工？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.view hudShow];
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/affirmComplete.do"];
        NSDictionary *paramDic = @{@"constructionId":@(model.siteId),
                                   @"agencyId":@(user.agencyId),
                                   @"companyId":model.companyId.length>0?model.companyId:@"0"
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            [self.view hiddleHud];
            if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                
                NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                
                switch (statusCode) {
                    case 1000:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"交工成功" controller:self sleep:1.5];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"CompleteContruct" object:nil];
                    }
                        break;
                        
                    case 1001:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"交工失败" controller:self sleep:1.5];
                    }
                        break;
                        
                    case 1002:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"没有交工的权限" controller:self sleep:1.5];
                    }
                        break;
                        
                    case 1003:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"工地还没有完工" controller:self sleep:1.5];
                    }
                        break;
                        
                    case 2000:
                        
                    {
                        [[PublicTool defaultTool] publicToolsHUDStr:@"出错了" controller:self sleep:1.5];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
        } failed:^(NSString *errorMsg) {
            [self.view hiddleHud];
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }];
    }];
    [alertC addAction:alert1];
    [alertC addAction:alert2];
    [self presentViewController:alertC animated:YES completion:nil];
}

// 全部公司状态按钮事件
-(void)HandleccompleteWith:(NSIndexPath *)path tag:(NSInteger)tag{
    //1：可以交工，2：已交工未评论 3：已评论
    if (tag==1) {
        YSNLog(@"可以交工");
        
        NSInteger row = path.row;
        MySiteModel *model = self.siteArray[row];
        mySelectModel = model;
        [self sureCComplete];
    }
    if (tag==2) {
        YSNLog(@"已交工未评论");
        MySiteModel *model = self.siteArray[path.row];
        ZCHConstructionCommentController *commentVC = [UIStoryboard storyboardWithName:@"ZCHConstructionCommentController" bundle:nil].instantiateInitialViewController;
        commentVC.constructionId = model.constructionId;
        commentVC.isNewComment = YES;
        __weak typeof(self) weakSelf = self;
        commentVC.refreshBlock = ^() {
            
            [weakSelf refreshData];
        };
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }
    if (tag==3) {
        YSNLog(@"已评论");
        MySiteModel *model = self.siteArray[path.row];
        ZCHConstructionCommentController *commentVC = [UIStoryboard storyboardWithName:@"ZCHConstructionCommentController" bundle:nil].instantiateInitialViewController;
        commentVC.constructionId = model.constructionId;
        commentVC.isNewComment = NO;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}


#pragma mark - 推送工地
- (void)HandPushWith:(NSIndexPath *)path {
    

    self.indexPath = path;
    MySiteModel *model = self.siteArray[path.row];
    // isProprietor是否为也只标识 >0则表示为业主
    if ([model.isProprietor integerValue] > 0) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您没有操作权限哦..."];
        return;
    }
        // 弹出推送底部视图
        self.shadowView.hidden = NO;
        
        UIButton *btn = [self.view viewWithTag:1000];
        if ([model.top isEqualToString:@"0"]) {
            
            [btn setTitle:@"计算器" forState:UIControlStateNormal];
            // 1. 得到imageView和titleLabel的宽、高
            CGFloat imageWith = btn.imageView.frame.size.width;
            CGFloat imageHeight = btn.imageView.frame.size.height;
            
            CGFloat labelWidth = 0.0;
            CGFloat labelHeight = 0.0;
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
            UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
            UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
            btn.titleEdgeInsets = labelEdgeInsets;
            btn.imageEdgeInsets = imageEdgeInsets;
        } else {
            
            [btn setTitle:@"取消推送" forState:UIControlStateNormal];
            // 1. 得到imageView和titleLabel的宽、高
            CGFloat imageWith = btn.imageView.frame.size.width;
            CGFloat imageHeight = btn.imageView.frame.size.height;
            
            CGFloat labelWidth = 0.0;
            CGFloat labelHeight = 0.0;
            labelWidth = btn.titleLabel.intrinsicContentSize.width;
            labelHeight = btn.titleLabel.intrinsicContentSize.height;
            UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
            UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
            btn.titleEdgeInsets = labelEdgeInsets;
            btn.imageEdgeInsets = imageEdgeInsets;
        }
        
        UIButton *btnYellow = [self.view viewWithTag:1001];
        if ([model.isYellow isEqualToString:@"0"]) {
            
            [btnYellow setTitle:@"企业" forState:UIControlStateNormal];
            // 1. 得到imageView和titleLabel的宽、高
            CGFloat imageWith = btnYellow.imageView.frame.size.width;
            CGFloat imageHeight = btnYellow.imageView.frame.size.height;
            
            CGFloat labelWidth = 0.0;
            CGFloat labelHeight = 0.0;
            labelWidth = btnYellow.titleLabel.intrinsicContentSize.width;
            labelHeight = btnYellow.titleLabel.intrinsicContentSize.height;
            UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
            UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
            btnYellow.titleEdgeInsets = labelEdgeInsets;
            btnYellow.imageEdgeInsets = imageEdgeInsets;
        } else {
            
            [btnYellow setTitle:@"取消推送" forState:UIControlStateNormal];
            // 1. 得到imageView和titleLabel的宽、高
            CGFloat imageWith = btnYellow.imageView.frame.size.width;
            CGFloat imageHeight = btnYellow.imageView.frame.size.height;
            
            CGFloat labelWidth = 0.0;
            CGFloat labelHeight = 0.0;
            labelWidth = btnYellow.titleLabel.intrinsicContentSize.width;
            labelHeight = btnYellow.titleLabel.intrinsicContentSize.height;
            UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
            UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-5/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-5/2.0, 0);
            btnYellow.titleEdgeInsets = labelEdgeInsets;
            btnYellow.imageEdgeInsets = imageEdgeInsets;
        }
    
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomSendView.blej_y = BLEJHeight - (BLEJWidth * 0.3 + 40);
        } completion:^(BOOL finished) {
            self.shadowView.hidden = NO;
        }];
        
}

-(void)HandFlowerWith:(NSIndexPath *)path{

    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"敬请期待..."];
}

-(void)HanBannerWith:(NSIndexPath *)path{

    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"敬请期待..."];
}

#pragma mark - 是否交工按钮的响应事件
-(void)sureCComplete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"确认交工后将不能修改日志，是否确认交工？"
                                                   delegate:self
                                          cancelButtonTitle:@"否"
                                          otherButtonTitles:@"是",nil];
    alert.tag = 100;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/affirmComplete.do"];
            NSDictionary *paramDic = @{@"constructionId":@([mySelectModel.constructionId integerValue]),
                                       @"agencyId":@(user.agencyId),
                                       @"companyId":mySelectModel.companyId.length>0?mySelectModel.companyId:@"0"
                                       };
            [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
                
                if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
                    
                    NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
                    
                    switch (statusCode) {
                        case 1000:
                            
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"交工成功" controller:self sleep:1.5];
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"CompleteContruct" object:nil];
                        }
                            break;
                            
                        case 1001:
                            
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"交工失败" controller:self sleep:1.5];
                        }
                            ////                    NSDictionary *dic = [NSDictionary ]
                            break;
                            
                        case 1002:
                            
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"没有交工的权限" controller:self sleep:1.5];
                        }
                            ////                    NSDictionary *dic = [NSDictionary ]
                            break;
                            
                        case 1003:
                            
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"工地还没有完工" controller:self sleep:1.5];
                        }
                            ////                    NSDictionary *dic = [NSDictionary ]
                            break;
                            
                        case 2000:
                            
                        {
                            [[PublicTool defaultTool] publicToolsHUDStr:@"出错了" controller:self sleep:1.5];
                        }
                            ////                    NSDictionary *dic = [NSDictionary ]
                            break;
                            
                        default:
                            break;
                    }
                    
                    
                    
                    
                    
                }
                
                //        NSLog(@"%@",responseObj);
            } failed:^(NSString *errorMsg) {
                
            }];
        }
    }
    
    if (alertView.tag == 200){
        if (buttonIndex == 1){
            
            
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            
            NSArray *QArray = @[@"装修公司",@"建材商铺"];
            
            [selection CreateTableview:QArray withTitle:@"创建新店铺" setCompletionBlock:^(int tag) {
                YSNLog(@"%d",tag);
                CreatShopController *vc =[[CreatShopController alloc]init];
                //        vc.areaListArray = self.areaListArray;
                vc.companyId = [NSString stringWithFormat:@"%ld",_companyId];
                vc.isFirst = YES;
                vc.creatType = tag+1;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
             ];
        }
        
    }
    
}

-(void)searchClick:(UIButton*)sender{
    isAeraNameNoexit = YES;
    _allSitePageNum = 1;
    _notCompletionPageNum = 1;
    if (_segmentSelectType == SegmentSelectedTypeAllSite) {
        [self getSiteListArray];
    } else {
        [self getNotCompeltionSiteList];
    }
}


-(void)getSiteListArray{
    [self.view endEditing:YES];
    NSString *textStr = self.searchTF.text;
    if (!textStr||textStr.length<=0) {
        textStr = @"";
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/getMineByPage.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"ccAreaName":textStr,
                               @"pageNo":@(_allSitePageNum),
                               @"pageSize":@(8)
                               };
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if (responseObj&&[responseObj[@"code"]integerValue]==1000) {
            
            if ([[responseObj[@"data"] objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [responseObj[@"data"] objectForKey:@"list"];
                if (_allSitePageNum == 1) {
                    [self.siteArray removeAllObjects];
                } else {
                    
                }
                NSArray *arr = [NSArray yy_modelArrayWithClass:[MySiteModel class] json:array];
                [self.siteArray addObjectsFromArray:arr];
            };
        }

        if (_allSitePageNum == 1) {
            [self.siteTableView.mj_header endRefreshing];
        } else {
            [self.siteTableView.mj_footer endRefreshing];
        }
        //                        //刷新数据
        [self.siteTableView reloadData];
        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
        self.siteTableView.tableFooterView = self.siteArray.count > 0 ? fView : self.footerView;
    } failed:^(NSString *errorMsg) {
        if (_allSitePageNum == 1) {
            [self.siteTableView.mj_header endRefreshing];
        } else {
            [self.siteTableView.mj_footer endRefreshing];
        }
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

-(void)getNotCompeltionSiteList{
    
    UserInfoModel *user = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getListByPage.do"];
    
    if (!self.searchTF.text||self.searchTF.text.length<=0) {
        self.searchTF.text = @"";
    }
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"ccHouseholderName":self.searchTF.text,
                               @"pageNum":@(_notCompletionPageNum)
                               };
    NSLog(@"paradic-----%@",paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *array = responseObj[@"data"][@"constructionList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[SiteModel class] json:array];
                        if (_notCompletionPageNum == 1) {
                            [self.notCompletionSiteArray removeAllObjects];
                        }
                        [self.notCompletionSiteArray addObjectsFromArray:arr];
                        
                        if (_notCompletionPageNum == 1) {
                            [self.siteTableView.mj_header endRefreshing];
                        } else {
                            [self.siteTableView.mj_footer endRefreshing];
                        }
                        [self.siteTableView reloadData];
                        UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
                        self.siteTableView.tableFooterView = self.notCompletionSiteArray.count > 0 ? fView : self.footerView;
                        
                    };
                    break;
                    
                default:
                    break;
            }
            if (_notCompletionPageNum == 1) {
                [self.siteTableView.mj_header endRefreshing];
            } else {
                [self.siteTableView.mj_footer endRefreshing];
            }
        }
        
    } failed:^(NSString *errorMsg) {
        if (_notCompletionPageNum == 1) {
            [self.siteTableView.mj_header endRefreshing];
        } else {
            [self.siteTableView.mj_footer endRefreshing];
        }
    }];
    
}

#pragma mark - 推送工地(计算器 云管理会员)
- (void)setSendConstructionWithIndex:(NSIndexPath *)index {
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"construction/topToCal.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj) {
            
            NSInteger code = [responseObj[@"code"] integerValue];
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bottomSendView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                
                self.shadowView.hidden = YES;
            }];
            switch (code) {
                case 1000:
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送成功"];
                    model.top = @"1";
                    [self.siteTableView reloadData];
                    break;
                }
                case 1001:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不属于该工地"];
                    break;
                case 1002:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不是工地的总经理或经理"];
                    break;
                case 1003:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司已不存在"];
                    break;
                case 1004:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"工地已不存在"];
                    break;
                case 1005:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不属于公司"];
                    break;
                case 1006:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不是公司的总经理或经理"];
                    break;
                case 1007:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送失败，推送到计算器数量已达上限"];
                    break;
                case 1008:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"公司没有开通施工云管理会员"];
                    break;
                case 2000:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送失败"];
                    break;
                default:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送失败"];
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 取消推送工地(日志 计算器)
- (void)cancelSendConstructionWithIndex:(NSIndexPath *)index {
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"construction/cancelTopCal.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"取消推送成功"];
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bottomSendView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                
                self.shadowView.hidden = YES;
            }];
            model.top = @"0";
            [self.siteTableView reloadData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"取消推送失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 推送工地(企业)
- (void)setSendYellowPageWithIndex:(NSIndexPath *)index {
    
    if ([self.agencysJob isEqualToString:@"1003"]||[self.agencysJob isEqualToString:@"1010"]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"没有操作权限"];
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottomSendView.blej_y = BLEJHeight;
        } completion:^(BOOL finished) {
            
            self.shadowView.hidden = YES;
        }];
        return;
    }
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"construction/toYellowPage.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId,
                            @"companyId" : model.companyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj) {
            
            NSInteger code = [responseObj[@"code"] integerValue];
            switch (code) {
                case 1000:
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送成功"];
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.bottomSendView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        
                        self.shadowView.hidden = YES;
                    }];
                    model.isYellow = @"1";
                    [self.siteTableView reloadData];
                    break;
                }
                case 1001:
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您不属于该工地"];
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.bottomSendView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        
                        self.shadowView.hidden = YES;
                    }];
                    break;
                }
                case 1002:
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您不是工地的总经理或经理"];
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.bottomSendView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        
                        self.shadowView.hidden = YES;
                    }];
                    break;
                }
                case 1003:
                {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送失败，推送到企业网数量已达上限"];
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.bottomSendView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        
                        self.shadowView.hidden = YES;
                    }];
                    break;
                }
                default:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"推送失败"];
                    [UIView animateWithDuration:0.25 animations:^{
                        
                        self.bottomSendView.blej_y = BLEJHeight;
                    } completion:^(BOOL finished) {
                        
                        self.shadowView.hidden = YES;
                    }];
                    break;
            }
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark - 取消推送工地(企业)
- (void)cancelSendYellowPageWithIndex:(NSIndexPath *)index {
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"construction/cancelYellow.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"取消推送成功"];
            [UIView animateWithDuration:0.25 animations:^{
                
                self.bottomSendView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                
                self.shadowView.hidden = YES;
            }];
            model.isYellow = @"0";
            [self.siteTableView reloadData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"取消推送失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}



#pragma mark - 置顶工地
- (void)setTopConstructionWithIndex:(NSIndexPath *)index {
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"constructionPerson/topMyCon.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"置顶成功"];
            _allSitePageNum = 1;
            [self getSiteListArray];
            [self.siteTableView reloadData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"置顶失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow showHudFailed:NETERROR];
    }];
}

#pragma mark - 取消置顶工地
- (void)cancelTopConstructionWithIndex:(NSIndexPath *)index {
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"constructionPerson/cancleMyCon.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"取消置顶成功"];
            _allSitePageNum = 1;
            [self getSiteListArray];
            [self.siteTableView reloadData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"取消置顶失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow showHudFailed:NETERROR];
    }];
}


#pragma mark - 删除工地
- (void)deleteConstructionWithIndex:(NSIndexPath *)index {
    
    MySiteModel *model = self.siteArray[index.row];
    NSString *agencyId = [[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"];
    NSString *apiURL = [BASEURL stringByAppendingString:@"construction/confirmDeleteById.do"];
    NSDictionary *param = @{
                            @"constructionId" : model.constructionId,
                            @"agencyId" : agencyId
                            };
    
    [NetManager afPostRequest:apiURL parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteContruct" object:nil];
            [self.siteArray removeObjectAtIndex:index.section];
            [self.siteTableView reloadData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"删除失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow showHudFailed:NETERROR];
    }];
}

#pragma mark - 是否在企业网显示
- (void)didClickIsSelectBtn:(NSIndexPath *)path {
    
    MySiteModel *model = self.siteArray[path.row];
    NSString *apiStr = [BASEURL stringByAppendingString:@"construction/updateByDisplay.do"];
    NSArray *paramArr = @[@{
                            @"id" : model.constructionId,
                            @"isDisplay" : [model.isDisplay isEqualToString:@"0"] ? @"1" : @"0"
                            }];
    NSData *jsonDataBase = [NSJSONSerialization dataWithJSONObject:paramArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStrBase = [[NSString alloc]initWithData:jsonDataBase encoding:NSUTF8StringEncoding];
    NSDictionary *param = @{
                          @"constructionList" : jsonStrBase
                          };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj) {
            
            NSInteger code = [responseObj[@"code"] integerValue];
            switch (code) {
                case 1000:
                    
                    model.isDisplay = @"1";
                    break;
                case 2000:
                    
                    model.isDisplay = @"0";
                    break;
                default:
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"失败"];
                    break;
            }
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"失败"];
    }];
}

#pragma mark - 刷新数据

-(void)refreshData{
    _allSitePageNum = 1;
    _notCompletionPageNum = 1;
    if (_segmentSelectType == SegmentSelectedTypeAllSite) {
        [self getSiteListArray];
    } else {
        [self getNotCompeltionSiteList];
    }
}

#pragma mark - 加载更多数据

-(void)loadMoreData{
    [self.view endEditing:YES];
    NSString *textStr = self.searchTF.text;
    if (!textStr||textStr.length<=0) {
        textStr = @"";
    }
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/getMineByPage.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"ccAreaName":textStr,
                               @"pageNo":@(_allSitePageNum),
                               @"pageSize":@(8)
                               };
    [NetManager afGetRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.siteTableView.mj_footer endRefreshing];
        if (responseObj&&[responseObj[@"code"]integerValue]==1000) {
            YSNLog(@"%@",responseObj);
            
            if ([[responseObj[@"data"] objectForKey:@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [responseObj[@"data"] objectForKey:@"list"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[MySiteModel class] json:array];
                [self.siteArray addObjectsFromArray:arr];
                _allSitePageNum = _allSitePageNum+1;
                //                        //刷新数据
                [self.siteTableView reloadData];
                self.siteTableView.tableFooterView = self.siteArray.count > 0 ? [UIView new] : self.footerView;
            };
        }
        if (responseObj&&[responseObj[@"code"]integerValue]==1001){
            [[PublicTool defaultTool] publicToolsHUDStr:@"暂无数据" controller:self sleep:1.5];
        }
        
    } failed:^(NSString *errorMsg) {
        [self.siteTableView.mj_footer endRefreshing];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 推送按钮的点击事件
- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomSendView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        
        self.shadowView.hidden = YES;
    }];
}

- (void)didClickSendContentBtn:(UIButton *)btn {
    
    MySiteModel *model = self.siteArray[self.indexPath.row];
    
    if ([model.isConVip isEqualToString:@"0"] && ![btn.titleLabel.text containsString:@"取消"]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottomSendView.blej_y = BLEJHeight;
        } completion:^(BOOL finished) {
            
            self.shadowView.hidden = YES;
        }];
        
        
        if ([model.companyId isEqualToString:@"0"] || [model.companyId isEqualToString:@""]) {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该公司不存在..."];
            return;
        }

    }
    
    if (btn.tag == 1000) {
        

            if ([btn.titleLabel.text isEqualToString:@"计算器"]) {
                
                [self setSendConstructionWithIndex:self.indexPath];
            } else {
                
                [self cancelSendConstructionWithIndex:self.indexPath];
            }
    }
    
    if (btn.tag == 1001) {
        

            if ([btn.titleLabel.text isEqualToString:@"企业"]) {
                // 推送到企业
                [self setSendYellowPageWithIndex:self.indexPath];
            } else {
                // 取消推送到企业
                [self cancelSendYellowPageWithIndex:self.indexPath];
            }
    }

}

-(void)reloadData:(UITextField*)sender{
    
    if (sender.text.length == 0) {
        _allSitePageNum = 1;
        _notCompletionPageNum = 1;
        if (_segmentSelectType == SegmentSelectedTypeAllSite) {
            [self getSiteListArray];
        } else {
            [self getNotCompeltionSiteList];
        }
    }
}

//销毁
- (void)dealloc
{
    self.returnKeyHandler = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
