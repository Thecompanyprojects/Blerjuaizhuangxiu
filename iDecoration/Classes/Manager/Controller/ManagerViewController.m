//
//  ManagerViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ManagerViewController.h"
#import "CreateCompanyViewController.h"
#import "CreateConstructionViewController.h"
#import "NewConstructionApi.h"
#import "VLoopScrollView.h"
#import "SiteTableViewCell.h"
#import "GetSiteListApi.h"
#import "SiteModel.h"
#import "GetSiteADImgApi.h"
#import "ADImageModel.h"
#import "ConstructionDiaryViewController.h"
#import "GetSiteInfoByIDApi.h"
#import "CreateConstructionViewController.h"
#import "MainMaterialDiaryController.h"
#import "SDCycleScrollView.h"
#import "CreatShopController.h"
#import "LoginViewController.h"
#import "ClickTextView.h"
#import "MyConstructionSiteViewController.h"
#import "SSPopup.h"
#import "JoinCompanyController.h"
#import "ZCHConstructionVipController.h"
#import "MeViewController.h"
#import <JPUSHService.h>

#import "VoteSetController.h"

#import "ConstructionDiaryTwoController.h"
#import "ZCHCityModel.h"
#import "AdvertisementWebViewController.h"
#import "VipGroupViewController.h"


//extern NSMutableString *globalCityNum;
//extern NSMutableString *globalCityName;
extern ZCHCityModel *cityModel;
extern ZCHCityModel *countyModel;

@interface ManagerViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SiteTableViewCellDelegate,SDCycleScrollViewDelegate,SSPopupDelegate>
{
    SiteModel *selectModel;
    NSInteger _companyId;
    
    NSInteger _pageNum;
    
    BOOL isLogin;
    
    NSInteger _selectCompanyId;//所选公司的id
    NSInteger _companyType;//所选公司的类型
}

@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *bannerImgArray;
@property (nonatomic, strong) NSMutableArray *bannerImgHrefArray;
@property (nonatomic, strong) UITableView *siteTableView;
@property (nonatomic, strong) NSMutableArray *siteArray;
@property (strong, nonatomic) UIImageView *bgImageView;
// 没有工地时的提示视图
@property (nonatomic, strong) ClickTextView *clickTextView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *editBtn;
@end

@implementation ManagerViewController

-(NSMutableArray*)bannerImgArray{
    
    if (!_bannerImgArray) {
        _bannerImgArray = [NSMutableArray array];
    }
    return _bannerImgArray;
}

-(NSMutableArray*)siteArray{
    
    if (!_siteArray) {
        _siteArray = [NSMutableArray array];
    }
    return _siteArray;
}


- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
//        self.siteTableView.tableFooterView = _footerView;
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor lightGrayColor];
        label.tag = 888;
        label.text = @"还没有新工地?";
        [_footerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(30);
            make.left.right.equalTo(0);
        }];
        label.textAlignment = NSTextAlignmentCenter;
        
    }
    return _footerView;
}
- (ClickTextView *)clickTextView {
    if (!_clickTextView) {
        _clickTextView = [[ClickTextView alloc] initWithFrame:CGRectZero];
        [self.footerView addSubview:_clickTextView];
        UILabel *label = (UILabel *)[self.footerView viewWithTag:888];
        [_clickTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom);
            make.centerX.equalTo(0);
            make.height.equalTo(30);
        }];
        _clickTextView.font = [UIFont systemFontOfSize:14];
        _clickTextView.textColor = [UIColor lightGrayColor];
        _clickTextView.textAlignment = NSTextAlignmentCenter;
        _clickTextView.backgroundColor = [UIColor clearColor];
        
        NSString *content = @"新建工地或到我的工地查看以往工地";
        // 设置文字
        _clickTextView.text = content;
        
        // 设置期中的一段文字有下划线，下划线的颜色为蓝色，点击下划线文字有相关的点击效果
        NSRange range1 = [content rangeOfString:@"新建工地"];
        MJWeakSelf;
        [_clickTextView setUnderlineTextWithRange:range1 withUnderlineColor:[UIColor blueColor] withClickCoverColor:[UIColor clearColor] withBlock:^(NSString *clickText) {
            [weakSelf newSite];
        }];
        
        // 设置期中的一段文字有下划线，下划线的颜色没有设置，点击下划线文字没有点击效果
        NSRange range2 = [content rangeOfString:@"我的工地"];
        [_clickTextView setUnderlineTextWithRange:range2 withUnderlineColor:[UIColor blueColor] withClickCoverColor:[UIColor clearColor] withBlock:^(NSString *clickText) {
            MyConstructionSiteViewController *myConVC = [[MyConstructionSiteViewController alloc] init];
            [weakSelf.navigationController pushViewController:myConVC animated:YES];
        }];
    }
    return _clickTextView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bannerImgHrefArray = [NSMutableArray array];
    _pageNum = 1;
    [self getTitle];
    [self createUI];
    [self createTableView];
    [self createScrollView];
    [self getAdImgList];
    [self getSiteList];
    [self clickTextView];
    
    
    
    //退出登录
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QuitLoginRefresh) name:@"refreshManageVCData" object:nil];
    
    //交工成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"CompleteContruct" object:nil];
    
    //删除工地成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:@"deleteContruct" object:nil];
    
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
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self getAdImgList];
    
    isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    [self getMessageNumData];
    
}



-(void)createUI{
    
    self.view.backgroundColor = Bottom_Color;
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"新工地" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    self.editBtn = editBtn;
    [self.editBtn addTarget:self action:@selector(newSite) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    
    
}

-(void)dealloc{

}

#pragma mark - 退出登录

-(void)QuitLoginRefresh{
    self.searchTF.text = @"";

    [self refreshData];
}

#pragma mark - 退出工地

-(void)QuitContructrefreshList{
    [self refreshData];
    [[PublicTool defaultTool] publicToolsHUDStr:@"退出成功" controller:self sleep:2];
}

- (void)getAdImgList {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"construction/v2/getCityImgList.do"];
    UserInfoModel *userInfo = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    // 经纬度
    CLLocationDegrees tempLongitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLongitude"] doubleValue];
    CLLocationDegrees tempLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLatitude"] doubleValue];
    double _longitude = tempLongitude ? tempLongitude : 40.000000;
    double _latitude = tempLatitude ? tempLatitude :116.000000;
    
    
    NSDictionary *param = @{
                            @"longitude" : @(_longitude),
                            @"latitude" : @(_latitude),
                            @"provinceId" : cityModel ? cityModel.pid : @"0",
                            @"cityId" : cityModel ? cityModel.cityId : @"0",
                            @"countyId" : countyModel ? countyModel.cityId : @"0",
                            @"currentPerson": @(userInfo.agencyId)
                            };
    
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.bannerImgArray removeAllObjects];
            [self.bannerImgHrefArray removeAllObjects];
            NSArray *imgArr = responseObj[@"imgList"];
            if (imgArr.count > 0) {
                for (NSDictionary *dic in imgArr) {
                    
                    [self.bannerImgArray addObject:dic[@"picUrl"]];
                    [self.bannerImgHrefArray addObject:dic[@"picHref"]];
                }
                
                self.scrollView.imageURLStringsGroup = self.bannerImgArray;
                self.bgImageView.hidden = YES;
            } else {
                
                [self.bannerImgArray removeAllObjects];
                [self.bannerImgHrefArray removeAllObjects];
                self.scrollView.imageURLStringsGroup = self.bannerImgArray;
                self.bgImageView.image = [UIImage imageNamed:@"carousel"];
                self.bgImageView.hidden = NO;
            }
            
        }
        [self.siteTableView reloadData];
        self.siteTableView.tableFooterView = self.siteArray.count > 0 ? [UIView new] : self.footerView;
        
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

- (void)getUserLimit {
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
                            
                            // 不是会员或会员到期  不能创建工地
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

                        CreateConstructionViewController *companyVC = [[CreateConstructionViewController alloc]init];
                        companyVC.roleTypeId = responseObj[@"roleTypeId"];
                        companyVC.companyId = [dict objectForKey:@"companyId"];
                        companyVC.companyType = [[dict objectForKey:@"companyType"]integerValue];
                        companyVC.companyName = [dict objectForKey:@"companyName"];
                        [self.navigationController pushViewController:companyVC animated:YES];
                        
              
                        
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
                        self.editBtn.userInteractionEnabled = NO;
                        
                        [selection CreateTableview:QArray withTitle:@"选择公司" setCompletionBlock:^(int tag) {
                            YSNLog(@"%d",tag);
                            self.editBtn.userInteractionEnabled = YES;
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
                            
                            
                            CreateConstructionViewController *companyVC = [[CreateConstructionViewController alloc]init];
                            companyVC.roleTypeId = responseObj[@"roleTypeId"];
                            companyVC.companyId = [dict objectForKey:@"companyId"];
                            companyVC.companyType = [[dict objectForKey:@"companyType"]integerValue];

                            companyVC.companyName = [dict objectForKey:@"companyName"];
                            [self.navigationController pushViewController:companyVC animated:YES];
                            
                         
                            
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
                    /*
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                     message:@"您还没有公司，如果您是总经理请创建公司，其他职位请申请加入公司。"
                     delegate:self
                     cancelButtonTitle:@"取消"
                     otherButtonTitles:@"创建公司", @"加入公司",nil];
                     if (buttonIndex == 1) {
                     CreateCompanyViewController *vc = [[CreateCompanyViewController alloc]init];
                     [self.navigationController pushViewController:vc animated:YES];
                     }
                     if (buttonIndex == 2) {
                     JoinCompanyController *vc = [[JoinCompanyController alloc]init];
                     [self.navigationController pushViewController:vc animated:YES];
                     }
                     */
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您还不属于任何公司" preferredStyle:UIAlertControllerStyleAlert];
                    //
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

#pragma mark - 获取公司名称

-(void)getTitle{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/getCompanyByAgencyId.do"];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    NSString *titleStr = responseObj[@"companyName"];
                    self.navigationItem.title = titleStr;
                }
                    break;
                    
                default:
                    self.navigationItem.title = @"工地管理";
                    break;
            }

        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)createTableView{

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = White_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.siteTableView = tableView;
    self.siteTableView.tableFooterView = self.footerView;
    
    [self.siteTableView registerNib:[UINib nibWithNibName:@"SiteTableViewCell" bundle:nil] forCellReuseIdentifier:@"SiteTableViewCell"];
    
    self.siteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    self.siteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
    
}

-(void)createScrollView{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6 + 47)];
    
    //    self.scrollView = [[VLoopScrollView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, 180)];
    self.scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6) delegate:self placeholderImage:nil];
    self.scrollView.autoScrollTimeInterval = BANNERTIME;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, kSCREEN_WIDTH * 0.6)];

    [bgView addSubview:self.scrollView];
    [bgView addSubview:self.bgImageView];
    bgView.backgroundColor = kBackgroundColor;

    self.searchTF = [[UITextField alloc]initWithFrame:CGRectMake(10, kSCREEN_WIDTH * 0.6 + 7, kSCREEN_WIDTH-32-20, 36)];
    self.searchTF.delegate = self;
    self.searchTF.backgroundColor = White_Color;
    self.searchTF.layer.borderColor = Bottom_Color.CGColor;
    self.searchTF.layer.cornerRadius = 5;
    self.searchTF.layer.borderWidth = 1;
    self.searchTF.font = [UIFont systemFontOfSize:16];
    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF.placeholder = @"请输入户主名称";
    [bgView addSubview:self.searchTF];
    
    [[PublicTool defaultTool] publicToolsAddLeftViewWithTextField:self.searchTF];
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.searchTF.right + 2, kSCREEN_WIDTH * 0.6 + 8, 30, 30)];
    searchBtn.centerY = self.searchTF.centerY;
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];

    [bgView addSubview:searchBtn];
    self.siteTableView.tableHeaderView = bgView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.siteArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.0000000000000001;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SiteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.houseHoldLabel.font = [UIFont systemFontOfSize:16];
    cell.stateBtn.hidden = YES;
    cell.locationLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8 - 4;
    cell.companyLabelWidthCon.constant = kSCREEN_WIDTH / 2.0 - 8;
    if (self.siteArray.count>0) {
        id data = self.siteArray[indexPath.section];
        [cell configData:data];
    }
    
    cell.delegate = self;
    cell.path = indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SiteModel *site = self.siteArray[indexPath.section];
    NSInteger company = [site.companyType integerValue];
    if (company == 1018 || company == 1064 || company == 1065) {

        ConstructionDiaryTwoController *diaryVC = [[ConstructionDiaryTwoController alloc]init];
        diaryVC.consID = site.siteId;
        [self.navigationController pushViewController:diaryVC animated:YES];
    }
    else{
        MainMaterialDiaryController *diaryVC = [[MainMaterialDiaryController alloc]init];
        diaryVC.consID = site.siteId;
        [self.navigationController pushViewController:diaryVC animated:YES];
    }
    
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *webUrl = self.bannerImgHrefArray[index]; //self.topImageDicArray[index][@"picHref"];
    
    if (webUrl.length > 0) {
        if (![webUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
            return;
        }
        AdvertisementWebViewController *adWebViewVC = [[AdvertisementWebViewController alloc] init];
        adWebViewVC.webUrl = webUrl;
        [self.navigationController pushViewController:adWebViewVC animated:YES];
    }
}

#pragma mark - 刷新数据

-(void)refreshData{
    [self.view endEditing:YES];
    [self getTitle];
    
    UserInfoModel *user = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getListByPage.do"];
    if (!self.searchTF.text||self.searchTF.text.length<=0) {
        self.searchTF.text = @"";
    }
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"ccHouseholderName":self.searchTF.text,
                               @"pageNum":@(1)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.siteTableView.mj_header endRefreshing];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    [self.siteArray removeAllObjects];
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *array = responseObj[@"data"][@"constructionList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[SiteModel class] json:array];
                        [self.siteArray addObjectsFromArray:arr];
                        _pageNum = 2;
                        //
                        //                        //刷新数据
                        [self.siteTableView reloadData];
                        self.siteTableView.tableFooterView = self.siteArray.count > 0 ? [UIView new] : self.footerView;

                    };
                    break;
                    
                default:
                    break;
            }
            
        }

    } failed:^(NSString *errorMsg) {
        [self.siteTableView.mj_header endRefreshing];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 加载更多数据

-(void)loadMoreData{
    UserInfoModel *user = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getListByPage.do"];
    if (!self.searchTF.text||self.searchTF.text.length<=0) {
        self.searchTF.text = @"";
    }
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"ccHouseholderName":self.searchTF.text,
                               @"pageNum":@(_pageNum)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.siteTableView.mj_footer endRefreshing];
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *array = responseObj[@"data"][@"constructionList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[SiteModel class] json:array];
                        [self.siteArray addObjectsFromArray:arr];
         
                        _pageNum++;
                        [self.siteTableView reloadData];
                        self.siteTableView.tableFooterView = self.siteArray.count > 0 ? [UIView new] : self.footerView;
                    };

                    break;
                    
                default:
                    break;
            }

        }

    } failed:^(NSString *errorMsg) {
        [self.siteTableView.mj_footer endRefreshing];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - SiteTableViewCellDelegate

-(void)HandleccompleteWith:(NSIndexPath *)path{
    NSInteger row = path.section;
    SiteModel *model = self.siteArray[row];
    selectModel = model;
    [self sureCComplete];
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

-(void)getSiteList{
    
    [self.siteArray removeAllObjects];
    UserInfoModel *user = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getListByPage.do"];
    if (!self.searchTF.text||self.searchTF.text.length<=0) {
        self.searchTF.text = @"";
    }
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId),
                               @"ccHouseholderName":self.searchTF.text,
                               @"pageNum":@(1)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"data"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *array = responseObj[@"data"][@"constructionList"];
                        NSArray *arr = [NSArray yy_modelArrayWithClass:[SiteModel class] json:array];
                        [self.siteArray addObjectsFromArray:arr];
                        _pageNum = _pageNum+1;
                        //
                        //                        //刷新数据
                        [self.siteTableView reloadData];
                        self.siteTableView.tableFooterView = self.siteArray.count > 0 ? [UIView new] : self.footerView;
                        
                    };
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
    }];
    
}

-(void)newSite{
    
    if (!isLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.tag = 300;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
//    VoteSetController *vc = [[VoteSetController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self getUserLimit];
    
}

-(void)searchClick:(UIButton*)sender{
    
    [self getSiteList];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self refreshData];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self.view hudShow];
            UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
            NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/affirmComplete.do"];
            NSDictionary *paramDic = @{@"constructionId":@(selectModel.siteId),
                                       @"agencyId":@(user.agencyId),
                                       @"companyId":selectModel.companyId.length>0?selectModel.companyId:@"0"
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
                
                //        NSLog(@"%@",responseObj);
            } failed:^(NSString *errorMsg) {
                [self.view hiddleHud];
                [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
            }];
        }
    }
    
    if (alertView.tag == 200){
        if (buttonIndex == 1){
            self.editBtn.userInteractionEnabled = NO;
            
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            
            NSArray *QArray = @[@"装修公司", @"整装公司", @"新型装修",@"建材店铺"];
            
            [selection CreateTableview:QArray withTitle:@"创建新店铺" setCompletionBlock:^(int tag) {
                self.editBtn.userInteractionEnabled = YES;
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

-(void)disMissDoSomething{
    self.editBtn.userInteractionEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取消息数量

- (void)getMessageNumData {
    
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        __block NSInteger totalUnreadCount = 0;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 对话消息
#if DELETEHUANXIN
            // (@"注释掉环信")
#else
            // (@"打开环信代码")
            // 如果环信没有登录那么登录环信
            BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
            if (!isLoggedIn) {
                UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                if (!EMerror) {
                    [[EMClient sharedClient].options setIsAutoLogin:YES];
                }
            }
            
            NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
            for (EMConversation *conversation in conversations) {
                totalUnreadCount += conversation.unreadMessagesCount;
            }
#endif
        });
        
        
        NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
        if (!agencyid||agencyid == 0) {
            agencyid = 0;
        }
        UserInfoModel *userInfo = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"message/getMessageNum.do"];
        NSDictionary *paramDic = @{
                                   @"agencyId":@(agencyid),
                                   @"phone": @(userInfo.phone.integerValue)
                                   };
        
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(NSDictionary *responseObj) {
            // 加载成功
            
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            
            if (code == 1000) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *numDic = [responseObj objectForKey:@"data"];
                    NSInteger messageNum = [numDic[@"total"] integerValue];
                    messageNum += totalUnreadCount;
                    // 消息数量添加 使用说明提示
                    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                    if (kHasUseExpalinUpdate && !isReade) {
                        messageNum += 1;
                    }
                    
                    
                    NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)messageNum];
                    SNNavigationController *navi = self.tabBarController.viewControllers[3];
                    MeViewController *meVC = navi.viewControllers[0];
                    
                    if (messageNum > 99) {
                        meVC.tabBarItem.badgeValue = @"99+";
                    } else if (messageNum > 0) {
                        meVC.tabBarItem.badgeValue = messageNUMStr;
                    } else {
                        meVC.tabBarItem.badgeValue = nil;
                    }
                    [UIApplication sharedApplication].applicationIconBadgeNumber = messageNum;
                    if (messageNum == 0) {
                        [JPUSHService resetBadge];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kTabBarItemBadageValueChange" object:nil];
                });
                
                
            } else {
                NSDictionary *numDic = [responseObj objectForKey:@"data"];
                NSInteger messageNum = [numDic[@"total"] integerValue];
                messageNum += totalUnreadCount;
                // 消息数量添加 使用说明提示
                BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                if (kHasUseExpalinUpdate && !isReade) {
                    messageNum += 1;
                }
                
//                NSInteger messageNum = totalUnreadCount;
                NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)messageNum];
                SNNavigationController *navi = self.tabBarController.viewControllers[3];
                MeViewController *meVC = navi.viewControllers[0];
                
                if (messageNum > 99) {
                    meVC.tabBarItem.badgeValue = @"99+";
                } else if (messageNum > 0) {
                    meVC.tabBarItem.badgeValue = messageNUMStr;
                } else {
                    meVC.tabBarItem.badgeValue = nil;
                }
                [UIApplication sharedApplication].applicationIconBadgeNumber = messageNum;
                if (messageNum == 0) {
                    [JPUSHService resetBadge];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kTabBarItemBadageValueChange" object:nil];
            }
            
        } failed:^(NSString *errorMsg) {
            //加载失败
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
            });
            
        }];
    }else {
        // 消息数量添加 使用说明提示
        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
        if (kHasUseExpalinUpdate && !isReade) {
            SNNavigationController *navi = self.tabBarController.viewControllers[3];
            MeViewController *meVC = navi.viewControllers[0];
            meVC.tabBarItem.badgeValue = @"1";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        } else {
            SNNavigationController *navi = self.tabBarController.viewControllers[3];
            MeViewController *meVC = navi.viewControllers[0];
            meVC.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        
    }
}

@end
