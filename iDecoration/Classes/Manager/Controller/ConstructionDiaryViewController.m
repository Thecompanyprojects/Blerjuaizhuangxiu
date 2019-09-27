//
//  ConstructionDiaryViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ConstructionDiaryViewController.h"
#import "MemberViewController.h"
#import "SiteInfoTableViewCell.h"
#import "OptionsTableViewCell.h"
#import "SiteStateTableViewCell.h"
#import "ClearShareView.h"
#import "QRCodeView.h"
#import "DesignImageViewController.h"
#import "DiaryTitleHeaderView.h"
#import "GetDiaryApi.h"
#import "NodeModel.h"
#import "SiteModel.h"
#import "CaseMaterialTwoModel.h"
#import "SignContractTableViewCell.h"
#import "SignContractViewController.h"
#import "EditJournalController.h"
#import "ModifyConstructionController.h"
#import "CaseMaterialCell.h"
#import "SDCycleScrollView.h"
#import "SGQRCodeTool.h"
#import "CaseMaterialController.h"
#import "SupervisorDiaryController.h"
#import "OwnerDiaryController.h"
#import "ConstructionMemberModel.h"
#import "TZImagePickerController.h"
#import "YPCommentView.h"
#import "MainMaterialDiaryController.h"
#import "ShopDetailViewController.h"
#import "CodeView.h"

#import "NoExitMemberController.h"
#import "NewDesignImageController.h"
#import "NSObject+CompressImage.h"



//extern NSMutableString *globalCityNum;
@interface ConstructionDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,DiaryTitleHeaderViewDelegate,SignContractTableViewCellDelegate,UIScrollViewDelegate,UITextViewDelegate,CaseMaterialCellDelegate,SDCycleScrollViewDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
{
    NSMutableDictionary *_sectionDict;
    NSInteger _nowNode;//当前节点
    NSInteger _nowCell;//我来添加按钮所在cell的index
    NSInteger _isFirstAdd;//是否是第一次添加
    
    BOOL selectNodeIsHave;//isadd tag
    
    BOOL isBottomVShow;//评论框是否显示,键盘是否弹出
    BOOL isPower;
    BOOL xsFlag;//是否显示我来添加节点
    BOOL isExit;//当前用户是否存在于当前工地
    BOOL isManage;//当前用户是否是工地的经理
    BOOL isDesiger;//当前用户是否是工地的设计师
    BOOL isZManage;//当前用户是否是工地的总经理
    BOOL isOwner;//当前用户是否是工地的业主
    CGFloat keyBoardHeight;
    CGFloat cellH;
    CGFloat caseCellH;
    
    NSIndexPath *_indexPath;
    
    BOOL implement;//是否是执行经理（0：不是，1：是）
    
}

@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) UIImageView *coverImgV;
@property (nonatomic, strong) ClearShareView *shareView;
@property (nonatomic, strong) UITableView *diaryTableView;
@property (nonatomic, strong) NSMutableArray *nodeArr;
@property (nonatomic, strong) SiteModel *siteModel;

@property (nonatomic, assign) NSInteger cJobTypeId;

@property (nonatomic, strong)UIView *bottomV;
@property (nonatomic, strong)UITextView *leaveWordTV;
@property (nonatomic, strong)UILabel *placeholderL;
@property (nonatomic, strong)UIButton *sendBtn;

@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) NSMutableArray *caseDataArray;
@property (nonatomic, strong) NSMutableArray *bannerImgArray;//轮播图数组

@property (nonatomic, strong)UIView *bottomLogoV;
@property (nonatomic, strong)UIImageView *bottomLogoImg;

@property (nonatomic, strong)UIView *heavV;

// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 遮罩层
@property (strong, nonatomic) UIView *shadowView;

// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 二维码
@property (strong, nonatomic) CodeView *TwoDimensionCodeView;

@property (nonatomic, strong) NSMutableDictionary *tapedDic; // 是否有舒展的Cell;

@property (nonatomic, strong) NSMutableDictionary *cellHDict;//cell高的字典

@property (nonatomic, strong) SiteInfoTableViewCell *siteInfoCell;
// 通过标识避免判断添加节点权限时重复点击问题
@property (nonatomic, assign) BOOL isDoRequest;
@end

@implementation ConstructionDiaryViewController
-(NSMutableArray*)nodeArr{
    
    if (!_nodeArr) {
        _nodeArr = [NSMutableArray array];
    }
    return _nodeArr;
}

-(NSMutableArray*)caseDataArray{
    
    if (!_caseDataArray) {
        _caseDataArray = [NSMutableArray array];
    }
    return _caseDataArray;
}

-(NSMutableArray*)bannerImgArray{
    
    if (!_bannerImgArray) {
        _bannerImgArray = [NSMutableArray array];
    }
    return _bannerImgArray;
}

-(NSMutableDictionary*)cellHDict{
    
    if (!_cellHDict) {
        _cellHDict = [NSMutableDictionary dictionary];
    }
    return _cellHDict;
}

-(NSMutableArray*)imgArray{
    
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isDoRequest = NO;
    
    self.tapedDic = [NSMutableDictionary dictionary];
    
    [self createUI];
    [self getDiaryData];
    [self createTableView];
    
    [self.view addSubview:self.bottomV];
    [self.bottomV addSubview:self.leaveWordTV];
    [self.leaveWordTV addSubview:self.placeholderL];
    [self.bottomV addSubview:self.sendBtn];
    [self addBottomShareView];
    
    
    isBottomVShow = NO;
    
    
    
    //监听键盘的隐藏和显示
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MobClick beginLogPageView:@"施工日志"];
    [MobClick event:@"ConstrustionDiary"];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];

    manager.enable = NO;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"施工日志"];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
    
    if (isBottomVShow) {
        [self.view endEditing:YES];
    }
}

-(void)createUI{
    
    self.title = @"施工日志";
    self.view.backgroundColor = Bottom_Color;
    _sectionDict = [NSMutableDictionary dictionary];
    
    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"分享" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
}

- (void)addBottomShareView {
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.shadowView addGestureRecognizer:tap];
    
    [self.view addSubview:self.shadowView];
    self.shadowView.hidden = YES;
    
    self.bottomShareView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth, 150 )];
    self.bottomShareView.backgroundColor = White_Color;
    [self.shadowView addSubview:self.bottomShareView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, BLEJWidth - 40, 30)];
    titleLabel.text = @"分享给好友";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottomShareView addSubview:titleLabel];
    
    
    
    NSArray *imageNames = @[@"weixin-share", @"pengyouquan", @"qq", @"qqkongjian", @"erweima-0"];
    NSArray *names = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"我的二维码"];
    for (int i = 0; i < 5; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * BLEJWidth * 0.2, titleLabel.bottom + 20, BLEJWidth * 0.2, BLEJWidth * 0.2)];
        btn.tag = i;
        [btn addTarget:self action:@selector(didClickShareContentBtn:) forControlEvents:UIControlEventTouchUpInside];
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
        
        [self.bottomShareView addSubview:btn];
    }
    
}

-(void)dealloc{
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}



#pragma mark - 添加二维码
- (void)addTwoDimensionCodeView {

    self.TwoDimensionCodeView = [[CodeView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.siteModel.companyLogo]];
    UIImage *image = [UIImage imageWithData:data];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.TwoDimensionCodeView.QRCodeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:image logoScaleToSuperView:0.3];
        });
    });
    self.TwoDimensionCodeView.typeLabel.text = [NSString stringWithFormat:@"%@",self.siteModel.ccShareTitle];
    self.TwoDimensionCodeView.areaLabel.text = [NSString stringWithFormat:@"%@/%@", self.siteModel.ccAcreage, self.siteModel.style];
    self.TwoDimensionCodeView.companyNameLabel.text = self.siteModel.ccBuilder;
    self.TwoDimensionCodeView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.TwoDimensionCodeView.imageView.clipsToBounds = YES;
    [self.TwoDimensionCodeView.imageView sd_setImageWithURL:[NSURL URLWithString:self.siteModel.coverMap]];
    // 没有图片
    if (self.siteModel.coverMap.length == 0) {
        [self.TwoDimensionCodeView.labelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(0);
            make.bottom.equalTo(-(kSCREEN_HEIGHT - 62-20));
            make.height.equalTo(62);
        }];
        
        [self.TwoDimensionCodeView.QRCodeImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH*0.4, kSCREEN_WIDTH * 0.4));
            make.centerX.equalTo(0);
            make.centerY.equalTo(0);
        }];
        
        [self.TwoDimensionCodeView.visitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.left.right.equalTo(0);
            make.top.equalTo(self.TwoDimensionCodeView.labelView.mas_bottom);
            make.bottom.equalTo(self.TwoDimensionCodeView.QRCodeImageView.mas_top);
        }];
    }

    self.TwoDimensionCodeView.hidden = YES;
}

-(void)createTableView{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:@"SiteInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"SiteInfoTableViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"OptionsTableViewCell" bundle:nil] forCellReuseIdentifier:@"OptionsTableViewCell"];
    [tableView registerClass:[DiaryTitleHeaderView class] forHeaderFooterViewReuseIdentifier:@"DiaryTitleHeaderView"];
    
    self.diaryTableView = tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.nodeArr.count+2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section >=2) {

            NSString *string = [NSString stringWithFormat:@"%ld",section];
            if ([_sectionDict[string] integerValue] == 1 ) {  //打开cell返回数组的count
                NodeModel *model = self.nodeArr[section-2];
                NSArray *arr = model.journalList;
                
                
                
                if ([model.crNodeNumber integerValue]==2010) {
                    return self.caseDataArray.count;
                }
                else{
                    return arr.count;
                }
                
            }else{
                return 0;
            }
        
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 200;
    }
    if (section>=2) {
        return 60.0f;
    }
    return 0.0000000000000001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        return 5;
    }
    else if (section==12){
        return 60;
    }
    else{
        return 5;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    __weak ConstructionDiaryViewController *weakSelf = self;
    
    if (section==0) {
//        UIView *heavV = [[UIView alloc]init];
        if (!_heavV) {
            _heavV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        }
        //        footV.backgroundColor = Red_Color;
        
        if (!_coverImgV) {
            _coverImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
            
            [self.view addSubview:self.heavV];
            [self.heavV addSubview:self.coverImgV];
        }
        
        
        [self.coverImgV sd_setImageWithURL:[NSURL URLWithString:self.siteModel.coverMap] placeholderImage:nil];
        
        return self.heavV;
    }
    
    if (section >=2) {
        
        DiaryTitleHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"DiaryTitleHeaderView"];
        headerView.delegate = self;
        headerView.addBtn.tag = section;
        if (self.nodeArr.count<=0) {
            return [[UITableViewHeaderFooterView alloc]init];;
        }
        NodeModel *node = self.nodeArr[section-2];
        headerView.title.text = node.crRoleName;
        NSURL *url = [NSURL URLWithString:node.crRoleImg];
        [headerView.logo sd_setImageWithURL:url placeholderImage:nil];
        
        
        //判断当前节点有没有数据
        
        
        if (node.journalList.count<=0) {
            headerView.rowImgV.hidden = YES;
        }
        else{
            headerView.rowImgV.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"%ld",section];
            if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                headerView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
            }else{//反之关闭cell
                headerView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
            }
        }
        
        if ([node.crNodeNumber integerValue]==2010) {
            //本案主材的节点
            if (self.caseDataArray.count<=0) {
                headerView.rowImgV.hidden = YES;
            }
            else{
                headerView.rowImgV.hidden = NO;
                
                NSString *str = @"11";
                if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                    headerView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
                }else{//反之关闭cell
                    headerView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
                }
            }
        }
        
        headerView.tag = 300 + section;
        __weak typeof(DiaryTitleHeaderView) *weakView = headerView;
        headerView.tapBlock = ^(){
            
            
            NSString *str = [NSString stringWithFormat:@"%ld",headerView.tag - 300];
            
            if ([_sectionDict[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
                [_sectionDict setObject:@"1" forKey:str];
                
                weakView.rowImgV.image = [UIImage imageNamed:@"row_top.png"];
            }else{//反之关闭cell
                [_sectionDict setObject:@"0" forKey:str];
                weakView.rowImgV.image = [UIImage imageNamed:@"row_bottom.png"];
            }
            
            NSInteger selectTag = [node.crNodeNumber integerValue];//点击的节点
            if (selectTag==2010) {
                if (self.caseDataArray.count<=0) {
                    
                }else{

                    
                    NSString *str = [NSString stringWithFormat:@"%ld",section];
                    
                    if ([_sectionDict[str] integerValue] == 1){
                        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:section];
//                        [weakSelf.diaryTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }
                    
                }
                
            }
            
            else{
                if (_nowNode==selectTag) {
                    //当前节点等于点击的节点,并且当前节点没有数据
                    if (node.journalList.count<=0) {
                        selectNodeIsHave = NO;
                        [weakSelf requestNextPointPower:selectTag];
                    }else{

                        NSString *str = [NSString stringWithFormat:@"%ld",section];
                        
                        if ([_sectionDict[str] integerValue] == 1){

                        }
                        
                    }
                    
                }
                else if (_nowNode>selectTag)
                {
                    //当前节点大于点击的节点

                    NSString *str = [NSString stringWithFormat:@"%ld",section];
                    
                    if ([_sectionDict[str] integerValue] == 1){


                    }

                }
                else{
                    //当前节点小于点击的节点
                    NSInteger cha = selectTag - _nowNode;
                    if (cha>1) {
                        if (selectTag==2011&&_nowNode==2009) {
                            //点击的节点是最后一个，当前的节点是油漆工程。判断油漆工程的节点是否有数据，无--提示添加油漆工程的节点，有--直接判断最后一个节点的权限
                            NodeModel *tempnode = self.nodeArr[8];
                            if (!tempnode.journalList.count) {
                                [[PublicTool defaultTool] publicToolsHUDStr:@"请填写添加油漆工程的节点" controller:self sleep:1.5];
                                return ;
                            }
                            else{
                                selectNodeIsHave = NO;
                                [weakSelf requestNextPointPower:selectTag];
                            }
                            
                        }else{
                            [[PublicTool defaultTool] publicToolsHUDStr:@"请填写上一个节点" controller:self sleep:1.5];
                        }
                        
                    }
                    else{
                        
                        NodeModel *model;
                        for (NodeModel *temModel in self.nodeArr) {
                            if ([temModel.crNodeNumber integerValue]==_nowNode) {
                                model = temModel;
                                break;
                            }
                        }
                        
                        NSArray *arr = model.journalList;
                        if (arr.count){
                            selectNodeIsHave = NO;
                            [weakSelf requestNextPointPower:selectTag];
                        }
                        else{
                            [[PublicTool defaultTool] publicToolsHUDStr:@"请填写上一个节点" controller:self sleep:1.5];
                        }
                        
                    }
                }
            }
//            [weakSelf.diaryTableView beginUpdates];
            //一个section刷新
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
            [weakSelf.diaryTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

//            [weakSelf.diaryTableView endUpdates];
        };
        //        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        
        if (self.siteModel.ccComplete==0||self.siteModel.ccComplete==1) {
            //未交工，再做判断 --- 当前节点是否有权限
            NodeModel *model = self.nodeArr[section-2];
            if ([model.crNodeNumber integerValue]==2010) {
                //本案主材的节点，没有数据，显示添加   有数据，判断xsflag，有权限--显示继续添加，没有权限，隐藏按钮
                headerView.addBtn.hidden = NO;
                
                if (self.caseDataArray.count<=0) {
                    [headerView.addBtn setTitle:@"添加" forState:UIControlStateNormal];
                }else{
                    if (!xsFlag) {
                        headerView.addBtn.hidden = YES;
                    }
                    else{
                        headerView.addBtn.hidden = NO;
                        [headerView.addBtn setTitle:@"继续添加" forState:UIControlStateNormal];
                    }
                   
                }
//                _nowCell = section;
            }else{
                if ([model.crNodeNumber integerValue]==_nowNode) {
                    headerView.addBtn.hidden = !isPower;
                    _nowCell = section;
                }
                else{
                    headerView.addBtn.hidden = YES;
                }
            }
            
        }
        else{
            //已交工 即不可以编辑也不可以添加
            headerView.addBtn.hidden = YES;
        }
        
        return headerView;
    }else{
        return [[UITableViewHeaderFooterView alloc]init];
    }
    
}


- (void)dealyMethod {
    CGPoint offset = CGPointMake(0, self.diaryTableView.contentSize.height - self.diaryTableView.frame.size.height);
    [self.diaryTableView setContentOffset:offset animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section==1) {
//        UIView *footV = [[UIView alloc]init];
////        footV.backgroundColor = Red_Color;
//        
//        if (!_scrollView) {
//            _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200) delegate:self placeholderImage:[UIImage imageNamed:@"carousel"]];
//        }
//        [footV addSubview:self.scrollView];
//        self.scrollView.imageURLStringsGroup = self.bannerImgArray;
//        
//        return footV;
//    }
    if (section==12) {
        if (!_bottomLogoV) {
            _bottomLogoV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
            _bottomLogoV.backgroundColor = Bottom_Color;
        }
        if (!_bottomLogoImg) {
            _bottomLogoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, kSCREEN_WIDTH, 40)];
            [_bottomLogoV addSubview:_bottomLogoImg];
        }
//        _bottomLogoImg.image =[UIImage imageNamed:@"bottomLogo"];
//        [_bottomLogoImg sizeToFit];
//        _bottomLogoImg.left = kSCREEN_WIDTH/2-_bottomLogoImg.width/2;
//        _bottomLogoImg.top = 30-_bottomLogoImg.height/2;
        return _bottomLogoV;
        
    }
    else{
        UIView *footV = [[UIView alloc]init];
        footV.backgroundColor = Bottom_Color;
        return footV;
//        return [[UITableViewHeaderFooterView alloc]init];
    }
}

//
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SiteInfoTableViewCell *cell = self.siteInfoCell;
        [cell configWith:self.siteModel];
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height + 1;
    }else if (indexPath.section==1){
        return 44;
    }
    else if (indexPath.section==11){
        return caseCellH;
    }
    else{
        NSString *indexSectionRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        if ([_sectionDict[sectionStr] integerValue] == 1 ) {  //打开cell返回数组的count
            CGFloat temH = [[self.cellHDict objectForKey:indexSectionRow] floatValue];
            return temH;
        }else{
            return 0;
        }
        
        
    }
    
    return 44;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return UITableViewAutomaticDimension;
////        return 476;
//    }else if (indexPath.section==1){
//        return 44;
//    }
//    else if (indexPath.section==11){
//        return caseCellH;
//    }
//    else{
//        NSString *sectionStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
//        if ([_sectionDict[sectionStr] integerValue] == 1 ) {  //打开cell返回数组的count
//            CGFloat temH = [[self.cellHDict objectForKey:sectionStr] floatValue];
//            return temH;
//        }else{
//            return 0;
//        }
//        
//        
//    }
//    
//    return 44;
//}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        SiteInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SiteInfoTableViewCell"];
        self.siteInfoCell  = [tableView dequeueReusableCellWithIdentifier:@"SiteInfoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.siteModel = self.siteModel;
        [cell configWith:self.siteModel];
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        //经理，总经理，创建人，可以编辑工地，并且未交工
        if ((self.siteModel.ccHouseholderId == user.agencyId||isZManage||isManage||implement)&&(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1)) {
            cell.modifyBtn.hidden = NO;
        }
        else{
            cell.modifyBtn.hidden = YES;
        }
//        cell.modifyBlock = ^{
//            [self editConstruction];
//        };
        
        return cell;
    }
    else if (indexPath.section == 1){
        
        OptionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.designBlock = ^{
            //调用接口，判断是否有数据 有---可以跳转 ，没有--判断是否有权限，有权限-跳转 ，没权限--提示设计师还未上传，请耐心等待
//            DesignImageViewController *designVC = [[DesignImageViewController alloc]init];
//            designVC.consID = self.consID;
//            [self.navigationController pushViewController:designVC animated:YES];
            [self requestDesignData];
        };
        
        cell.memberBlock = ^(){
            
            if (isExit) {
                MemberViewController *memberVC = [[MemberViewController alloc]init];
                //传递群组的ID
                memberVC.groupid = self.siteModel.groupId;
                memberVC.companyFlag = self.companyFlag;
                memberVC.consID = self.consID;
                memberVC.consCreatPeopleID = self.siteModel.ccHouseholderId;
                if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                    memberVC.isComplete = NO;
                }
                else{
                    memberVC.isComplete = YES;
                }
                [self.navigationController pushViewController:memberVC animated:YES];
            }
            else{
                NoExitMemberController *memberVC = [[NoExitMemberController alloc]init];
                memberVC.consID = self.consID;
//                memberVC.consCreatPeopleID = self.siteModel.ccHouseholderId;
                [self.navigationController pushViewController:memberVC animated:YES];
            }
            
        };
        
        cell.supervisorBlock = ^(){
            //调用接口，判断是否有数据 有---可以跳转 ，没有--判断是否有权限，有权限-跳转 ，没权限--提示监理还没有上传日志
            [self getsupervisionDiar];
        };
        
        cell.holderBlock = ^{
          //调用接口，判断是否有数据 有---可以跳转 ，没有--判断是否有权限，有权限-跳转 ，没权限--提示业主还没有上传日志
            [self getOwnerList];
        };
        
        return cell;
        
    }
    else if (indexPath.section == 11){
        CaseMaterialCell *cell = [CaseMaterialCell cellWithTableView:tableView indexpath:indexPath];
        CaseMaterialTwoModel *model = self.caseDataArray[indexPath.row];
        [cell configWith:model];
        caseCellH = cell.cellH;
        cell.delegate = self;
        
        if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3){
            cell.commentL.hidden = YES;
            cell.commentBtn.hidden = YES;
        }
        else{
            cell.commentL.hidden = NO;
            cell.commentBtn.hidden = NO;
        }
        
        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        
        if (model.agencysIds==user.agencyId) {
            cell.deleteBtn.hidden = NO;
        }
        else{
            cell.deleteBtn.hidden = YES;
        }
        return cell;
    }
    else{
            SignContractTableViewCell *cell = [SignContractTableViewCell cellWithTableView:tableView indexpath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            self.imgArray = cell.imgArray;
            cell.path = indexPath;
            NodeModel *model = self.nodeArr[indexPath.section-2];
            NSArray *arr = model.journalList;
            //            我来添加
            if (arr.count) {
                
                NSString *indexSectionRow = [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
                [self.cellHDict setObject:@(cell.cellH) forKey:indexSectionRow];

                if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3){
                    cell.discussBtn.hidden = YES;
                }
                else{
                    cell.discussBtn.hidden = NO;
                }
                
                if (indexPath.row == arr.count-1) {
                    cell.divView.hidden = YES;
  
                    
                }else{
                    cell.divView.hidden = NO;
                }
                
            }
        
        
       
        
            return cell;
        
    }
    
    
    
    
    
    return [[UITableViewCell alloc]init];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



#pragma mark–键盘显示事件

-(void)keyboardWillShow:(NSNotification *)notification{
    CGFloat cukeyBoardHeight = [[[notification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"]CGRectValue].size.height;
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //第三方键盘回调三次问题，监听仅执行最后一次
    if (begin.size.height>0&&begin.origin.y-end.origin.y>0) {
        keyBoardHeight = cukeyBoardHeight;
        
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.diaryTableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64-keyBoardHeight-44);
            self.bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT - keyBoardHeight-44, kSCREEN_WIDTH, 44);
            [self.diaryTableView scrollToRowAtIndexPath:_indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } completion:^(BOOL finished) {
            isBottomVShow = YES;
        }];
        
        
    }
}

-(void)keyBoardDidHide:(NSNotification *)notification{
    
    [UIView  animateWithDuration:0.05 animations:^{
        self.diaryTableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
        self.bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 44);
    }];
    
    isBottomVShow = NO;
}

-(void)editConstruction{
    ModifyConstructionController *vc = [[ModifyConstructionController alloc]init];
    vc.siteModel = self.siteModel;
    vc.consID = self.consID;
    vc.companyOrShop = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate


#pragma mark - DiaryTitleHeaderViewDelegate

-(void)addPointWith:(NSInteger)tag{
    NodeModel *model = self.nodeArr[tag-2];
    NSInteger selectTag = [model.crNodeNumber integerValue];

        [self requestNextPointPower:selectTag];

}

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{

}

-(void)textViewDidChange:(UITextView *)textView{
    self.leaveWordTV.text = textView.text;
    if (self.leaveWordTV.text.length == 0) {
        self.placeholderL.hidden = NO;
    }else{
        self.placeholderL.hidden = YES;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.leaveWordTV.text = textView.text;
    if (self.leaveWordTV.text.length == 0) {
        self.placeholderL.hidden = NO;
    }else{
        self.placeholderL.hidden = YES;
    }

}

#pragma mark CaseMaterialCellDelegate

-(void)CasecommentWith:(NSIndexPath *)path{
    
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    _indexPath = path;
    CGFloat keyH = 0;
    if (kSCREEN_WIDTH<350) {
        keyH = 253;
    }else if (kSCREEN_WIDTH<400){
        keyH = 258;
    }else{
        keyH = 271;
    }

    [self.leaveWordTV becomeFirstResponder];
}

-(void)CasezanWith:(NSIndexPath *)path{
    
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    [self caseRequestZanWith:path];
}



#pragma mark - SignContractTableViewCellDelegate


- (void)longPressCommentLabel:(UILabel *)label indexPath:(NSIndexPath *)path {
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"删除提示" message:@"删除后不可恢复!!！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *defaultApi = [BASEURL stringByAppendingString:@"comment/getDelete.do"];
        NSDictionary *paramDic = @{@"commentId":@(label.tag),
                                   };
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                {
                    [self.view hudShowWithText:@"删除成功"];
                    [self getDiaryDatawith:path];
                }
                    break;
                default:
                    break;
            }
        } failed:^(NSString *errorMsg) {
            
        }];

    }];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:YES completion:nil];
}
- (void)tapCommentLabel:(UILabel *)label IndexPath:(NSIndexPath *)path {
    // 记录被点击
    NSString *str = [NSString stringWithFormat:@"%ld", (path.row + 1)*(path.section + 1000)];
    [self.tapedDic setObject:path forKey:str];
    
    
    
    SignContractTableViewCell *cell = [self.diaryTableView cellForRowAtIndexPath:path];
    // cell的高度变化
    CGFloat xheight = 0;
    NSArray *subViews = cell.subviews;
    
    if (label.numberOfLines == 0) {
        label.numberOfLines = 1;
        
        CGRect frame = label.frame;
        xheight = label.font.lineHeight - frame.size.height;
        frame.size.height = label.font.lineHeight;
        label.frame = frame;
        
        NSUInteger index = [subViews indexOfObject:label];
        for (NSUInteger i = index + 1; i < subViews.count; i ++) {
            UILabel *label = [subViews objectAtIndex:i];
            CGRect frame = label.frame;
            frame.origin.y += xheight;
            label.frame = frame;
        }
        CGRect cellFrame = cell.frame;
        cellFrame.size.height += xheight;
        [cell setFrame:cellFrame];
        
        NSInteger sectionNum = [self.diaryTableView numberOfSections];
        for (NSInteger i = path.section + 1; i < sectionNum; i ++) {
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:i];
            SignContractTableViewCell *cell = [self.diaryTableView cellForRowAtIndexPath:indexP];
            CGRect frame = cell.frame;
            frame.origin.y += xheight;
            [cell setFrame:frame];
            
            UIView *headerView = [self.diaryTableView headerViewForSection:i];
            CGRect headerFrame = headerView.frame;
            headerFrame.origin.y += xheight;
            headerView.frame = headerFrame;
            
        }
        
    } else {
        label.numberOfLines = 0;
        // 开始为一行的时候
        CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH-10*2, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                               context:nil].size;
        xheight = textSize.height - label.font.lineHeight;
        CGRect frame = label.frame;
        frame.size.height = textSize.height;
        label.frame = frame;
        
        NSUInteger index = [subViews indexOfObject:label];
        for (NSUInteger i = index + 1; i < subViews.count; i ++) {
            UILabel *label = [subViews objectAtIndex:i];
            CGRect frame = label.frame;
            frame.origin.y += xheight;
            label.frame = frame;
        }
        CGRect cellFrame = cell.frame;
        cellFrame.size.height += xheight;
        [cell setFrame:cellFrame];
        
        NSInteger sectionNum = [self.diaryTableView numberOfSections];
        for (NSInteger i = path.section + 1; i < sectionNum; i ++) {
            NSIndexPath *indexP = [NSIndexPath indexPathForRow:0 inSection:i];
            SignContractTableViewCell *cell = [self.diaryTableView cellForRowAtIndexPath:indexP];
            CGRect frame = cell.frame;
            frame.origin.y += xheight;
            [cell setFrame:frame];
            
            UIView *headerView = [self.diaryTableView headerViewForSection:i];
            CGRect headerFrame = headerView.frame;
            headerFrame.origin.y += xheight;
            headerView.frame = headerFrame;
            
        }
    }
    
    
    
    
}


-(void)zanWith:(NSIndexPath *)path{
    [self requsetZanWith:path];
}

-(void)commentWith:(NSIndexPath *)path{
    
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    _indexPath = path;
//    _bottom
    CGFloat keyH = 0;
    if (kSCREEN_WIDTH<350) {
        keyH = 253;
    }else if (kSCREEN_WIDTH<400){
        keyH = 258;
    }else{
        keyH = 271;
    }
    [self.leaveWordTV becomeFirstResponder];

}

-(void)editWith:(NSIndexPath *)path{
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NodeModel *model = self.nodeArr[path.section-2];
    NSArray *journalList = model.journalList;
    if (journalList.count<=0) {
        return;
    }
    NSDictionary *dic = journalList[path.row];
    NSDictionary *cblejJournalModel = [dic objectForKey:@"cblejJournalModel"];
    NSInteger agencysId = [[cblejJournalModel objectForKey:@"agencysId"] integerValue];
    
    NSArray *imgArray = [dic objectForKey:@"imgList"];
    NSMutableArray *temImgArray = [NSMutableArray array];
    if (imgArray.count>0) {
        for (NSDictionary *imgDict in imgArray) {
            NSString *imgStr = [imgDict objectForKey:@"picUrl"];
            [temImgArray addObject:imgStr];
        }
    }
    NSArray *copyArray = [temImgArray copy];
    
    if (agencysId == user.agencyId) {
        EditJournalController *signVC = [[EditJournalController alloc]init];
        signVC.model = model;
        signVC.imgList = copyArray;
        signVC.contentStr = [cblejJournalModel objectForKey:@"content"];
        signVC.journalId = [cblejJournalModel objectForKey:@"journalId"];
        signVC.constructionId = self.consID;
        signVC.type = model.crNodeNumber;
        signVC.likeNum = [cblejJournalModel objectForKey:@"likeNum"];
        signVC.isAdd = @"1";
        signVC.titleStr = model.crRoleName;
        signVC.fromIndex = 1;
        signVC.companyId = self.companyId;
        signVC.agencysJob = self.agencysJob;
        [self.navigationController pushViewController:signVC animated:YES];
    }
    else{
        [[PublicTool defaultTool] publicToolsHUDStr:@"只能修改自己的填写的节点哦" controller:self sleep:1.5];
    }
    
}

-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray{
    __weak ConstructionDiaryViewController *weakSelf=self;
    YPImagePreviewController *yvc = [[YPImagePreviewController alloc]init];
    yvc.images = imgArray ;
    yvc.index = index ;

    UINavigationController *uvc = [[UINavigationController alloc]initWithRootViewController:yvc];
    [weakSelf presentViewController:uvc animated:YES completion:nil];
}

-(void)goCaseMatialVcWith:(NSIndexPath *)path{
    CaseMaterialTwoModel *model = self.caseDataArray[path.row];
    MainMaterialDiaryController *vc = [[MainMaterialDiaryController alloc]init];
    vc.consID = [model.materialConstructionId integerValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goShopWith:(NSIndexPath *)path{
    
    CaseMaterialTwoModel *model = self.caseDataArray[path.row];
    ShopDetailViewController *shopDetail = [[ShopDetailViewController alloc] init];
    shopDetail.shopName = model.companyName;
    shopDetail.shopID = model.merchantId;
    shopDetail.origin = self.origin;
    [self.navigationController pushViewController:shopDetail animated:YES];
}

-(void)shareClick:(UIBarButtonItem*)sender{
    

    self.shadowView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomShareView.blej_y = BLEJHeight - 150;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = NO;
    }];
    
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomShareView.blej_y = BLEJHeight;
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
    }];
    
    self.TwoDimensionCodeView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}

#pragma  mark - 分享
- (void)didClickShareContentBtn:(UIButton *)btn {
    NSString *shareTitle = self.siteModel.ccShareTitle;
    NSString *shareDescription = [NSString stringWithFormat:@"%@ %@", self.siteModel.ccBuilder, self.siteModel.ccAreaName];
    NSURL *shareImageUrl = nil;
//    if (self.siteModel.coverMap) {
        shareImageUrl = [NSURL URLWithString:self.siteModel.coverMap];
//    }
    UIImage *ima = [UIImage imageWithData:[NSData dataWithContentsOfURL:shareImageUrl]];
    UIImage *shareImage = [UIImage imageWithData:[NSObject imageWithImage:ima scaledToSize:CGSizeMake(300, 300)]];
    NSData *shareData = [NSObject imageWithImage:ima scaledToSize:CGSizeMake(300, 300)];
    
    
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            if (self.siteModel.coverMap) {
                [message setThumbImage:shareImage];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
//            NSString *shareURL = WebPageUrl;
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
            
            
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ConstructionDiaryShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 1:
        {// 微信朋友圈
            WXMediaMessage *message = [WXMediaMessage message];
            
            message.title = shareTitle;
            message.description = shareDescription;
            if (self.siteModel.coverMap) {
                [message setThumbImage:shareImage];
            } else {
                [message setThumbImage:[UIImage imageNamed:@"shareDefaultIcon"]];
            }
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            
            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ConstructionDiaryShare"];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomShareView.blej_y = BLEJHeight;
            } completion:^(BOOL finished) {
                self.shadowView.hidden = YES;
            }];
        }
            break;
        case 2:
        {// QQ好友
            if ([TencentOAuth iphoneQQInstalled]) {
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
                
                NSURL *url = [NSURL URLWithString:shareURL];
                // title = 分享标题
                // description = 施工单位 小区名称
                QQApiNewsObject *newObject;
                if (self.siteModel.coverMap) {
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    NSData *data = UIImagePNGRepresentation(image);
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                }
                
                
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ConstructionDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            
            break;
        case 3:
        {// QQ空间
            if ([TencentOAuth iphoneQQInstalled]){
                
                //声明一个新闻类对象
                self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
                //从contentObj中传入数据，生成一个QQReq
                
                NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID]];
                NSURL *url = [NSURL URLWithString:shareURL];
                
                QQApiNewsObject *newObject;
                if (self.siteModel.coverMap) {
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                } else {
                    UIImage *image = [UIImage imageNamed:@"shareDefaultIcon"];
                    NSData *data = UIImagePNGRepresentation(image);
                    newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:data];
                }
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ConstructionDiaryShare"];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    self.bottomShareView.blej_y = BLEJHeight;
                } completion:^(BOOL finished) {
                    self.shadowView.hidden = YES;
                }];
            }
        }
            break;
        case 4:
        {// 生成二维码
            [MobClick event:@"ConstructionDiaryShare"];
            self.TwoDimensionCodeView.hidden = NO;
            self.navigationController.navigationBar.alpha = 0;
        }
            break;
        default:
            break;
    }
    
    [NSObject contructionShareStatisticsWithConstructionId:[NSString stringWithFormat:@"%ld", self.consID]];
}

-(void)sendBtnClick{
    [self.view endEditing:YES];
    [UIView transitionWithView:self.view duration:0.3 options:0 animations:^{
        //执行的动画
        //        NSLog(@"动画开始执行前的位置：%@",NSStringFromCGPoint(self.customView.center));
        self.diaryTableView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
        self.bottomV.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 44);
    } completion:^(BOOL finished) {
        //动画执行完毕后的首位操作
        //        NSLog(@"动画执行完毕");
        //        NSLog(@"动画执行完毕后的位置：%@",NSStringFromCGPoint( self.customView.center));
    }];
    [self reqestCommentWith:_indexPath];
}

#pragma mark - 查询参与人员列表，判断当前人员是否存在于当前工地

#pragma mark -查询本案设计

-(void)requestDesignData{
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"design/getDesignInfrom.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
//                    DesignImageViewController *designVC = [[DesignImageViewController alloc]init];
                    NewDesignImageController *designVC = [[NewDesignImageController alloc]init];
                    designVC.consID = self.consID;
                    designVC.isPower = isDesiger;
                    if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                        //未交工
                        designVC.isComplate = NO;
                    }else{
                        designVC.isComplate = YES;
                    }
                    
                    [self.navigationController pushViewController:designVC animated:YES];
                    
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
//                    [self getDesignPower];
                    if (isDesiger) {
//                        DesignImageViewController *designVC = [[DesignImageViewController alloc]init];
                        NewDesignImageController *designVC = [[NewDesignImageController alloc]init];
                        designVC.consID = self.consID;
                        designVC.isPower = isDesiger;
                        if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                            //未交工
                            designVC.isComplate = NO;
                        }else{
                            designVC.isComplate = YES;
                        }
                        [self.navigationController pushViewController:designVC animated:YES];
                    }
                    else{
                        [[PublicTool defaultTool] publicToolsHUDStr:@"设计师还未上传，请耐心等待" controller:self sleep:1.5];
                    }
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

#pragma mark - 获取本案设计权限

-(void)getDesignPower{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"design/operatingAuthority.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"userId":@(user.agencyId),
                               @"nodeNumber":@(3001),
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    DesignImageViewController *vc = [[DesignImageViewController alloc]init];
                    vc.consID = self.consID;
                    if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                        //未交工
                        vc.isComplate = NO;
                    }else{
                        vc.isComplate = YES;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"设计师还未上传，请耐心等待" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 2000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
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

#pragma mark - 获取监理日志详情
-(void)getsupervisionDiar{
    NSMutableArray *tempInfo = [NSMutableArray array];
    NSMutableArray *tempContent = [NSMutableArray array];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"supervision/getRecords.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                    if ([responseObj[@"supervisionInfo"] isKindOfClass:[NSArray class]]) {
                        NSArray *info = responseObj[@"supervisionInfo"];
                        [tempInfo addObjectsFromArray:info];

                    };
                    
                    if ([responseObj[@"supervisionContent"] isKindOfClass:[NSArray class]]) {
                        NSArray *content = responseObj[@"supervisionContent"];

                        [tempContent addObjectsFromArray:content];
                    };
                    break;
                    
                case 1001:
                    
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            if ((tempInfo.count==0)&&(tempContent.count==0)) {
                [self judgeSuperversonJob];
            }
            else{
                SupervisorDiaryController *vc = [[SupervisorDiaryController alloc]init];
                vc.consID = self.consID;
                if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                    //未交工
                    vc.isComplete = NO;
                }else{
                    vc.isComplete = YES;
                }
                [self.navigationController pushViewController:vc animated:YES];
            }
            //            [self configurPhotosView];
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 判断监理职位

-(void)judgeSuperversonJob{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/getJobName.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencyId":@(user.agencyId),
                               @"nodeNumber":@(3004),
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    SupervisorDiaryController *vc = [[SupervisorDiaryController alloc]init];
                    vc.consID = self.consID;
                    if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                        //未交工
                        vc.isComplete = NO;
                    }else{
                        vc.isComplete = YES;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"监理还未上传内容，请耐心等待" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 2000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
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

#pragma mark - 获取业主日志

-(void)getOwnerList{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"ownerLog/getByConstructionId.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        YSNLog(@"%@",responseObj);
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    if ([responseObj[@"data"]isKindOfClass:[NSArray class]]){
                        NSArray *array = responseObj[@"data"];
                        
                        if (array.count<=0) {
//                            [self judgeOwnerPower];
                            if (isOwner) {
                                OwnerDiaryController *vc = [[OwnerDiaryController alloc]init];
                                vc.consID = self.consID;
                                if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                                    vc.isComplate = NO;
                                }
                                else{
                                    vc.isComplate = YES;
                                }
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            else{
                                [[PublicTool defaultTool] publicToolsHUDStr:@"业主暂未上传内容！" controller:self sleep:1.5];
                            }
                        }
                        else
                        {
                            OwnerDiaryController *vc = [[OwnerDiaryController alloc]init];
                            vc.consID = self.consID;
                            if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                                vc.isComplate = NO;
                            }
                            else{
                                vc.isComplate = YES;
                            }
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                        }
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

#pragma mark - 是否是业主
-(void)judgeOwnerPower{
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/getJobType.do"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"cpPersonId":@(user.agencyId),
                               @"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    OwnerDiaryController *vc = [[OwnerDiaryController alloc]init];
                    vc.consID = self.consID;
                    if(self.siteModel.ccComplete==0||self.siteModel.ccComplete==1){
                        vc.isComplate = NO;
                    }
                    else{
                        vc.isComplate = YES;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"业主暂未上传内容！" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 2000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 评论接口

-(void)reqestCommentWith:(NSIndexPath *)path{
    if (self.leaveWordTV.text.length<=0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"评论不能为空" controller:self sleep:1.5];
        return;
    }
    NSInteger type = 0;
    NodeModel *model = self.nodeArr[path.section-2];
    NSString *journalId = @"";
    if ([model.crRoleName isEqualToString:@"本案主材"]) {
        type = 1;
        CaseMaterialTwoModel *Casemodel = self.caseDataArray[path.row];
        journalId = Casemodel.materialId;
    }
    else{
        type = 0;
        NSArray *journalList = model.journalList;
        journalId = [[journalList[path.row] objectForKey:@"cblejJournalModel"] objectForKey:@"journalId"];
    }
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"comment/save.do"];
    NSDictionary *paramDic = @{@"journalId":journalId,
                               @"type":@(type),
                               @"agencyId":@(user.agencyId),
                               @"cpConstructionId":@(self.consID),
                               @"content":self.leaveWordTV.text
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        [self.view hiddleHud];
        self.leaveWordTV.text = @"";
        self.placeholderL.hidden = NO;
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
//                    [self.bottomV removeFromSuperview];
                    isBottomVShow = NO;
                    [[PublicTool defaultTool] publicToolsHUDStr:@"评论成功" controller:self sleep:1.5];
                    //                    NSInteger zanNum = [responseObj[@"likeNum"] integerValue];
                    
                    [self getDiaryDatawith:path];
                    
                    
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    //                case 1001:
                    //
                    //                {
                    //                    [[PublicTool defaultTool] publicToolsHUDStr:@"节点id为空" controller:self sleep:1.5];
                    //                }
                    //                    ////                    NSDictionary *dic = [NSDictionary ]
                    //                    break;
                    //                case 1002:
                    //
                    //                {
                    //                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞标识为空" controller:self sleep:1.5];
                    //                }
                    //                    ////                    NSDictionary *dic = [NSDictionary ]
                    //                    break;
                    //                case 1004:
                    //
                    //                {
                    //                    [[PublicTool defaultTool] publicToolsHUDStr:@"已经点过赞了" controller:self sleep:1.5];
                    //                }
                    //                    ////                    NSDictionary *dic = [NSDictionary ]
                    //                    break;
                    
                default:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"评论失败" controller:self sleep:1.5];
                }
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

#pragma mark - 本案主材点赞

-(void)caseRequestZanWith:(NSIndexPath *)path{
    CaseMaterialTwoModel *model = self.caseDataArray[path.row];
    NSString *journalId = model.materialId;
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journalMaterial/uplikeNum.do"];
    NSDictionary *paramDic = @{@"materialId":journalId,
                               @"agencysId":@(user.agencyId),
                               @"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞成功" controller:self sleep:1.5];
  
                    [self getDiaryDatawith:path];
                    
                    
                }
                    break;
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"节点id为空" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
//                case 1002:
//                    
//                {
//                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞标识为空" controller:self sleep:1.5];
//                }
//                    ////                    NSDictionary *dic = [NSDictionary ]
//                    break;
                case 1004:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"已经点过赞了" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞失败" controller:self sleep:1.5];
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 普通的点赞接口

-(void)requsetZanWith:(NSIndexPath *)path{
    NodeModel *model = self.nodeArr[path.section-2];
    NSArray *journalList = model.journalList;
    NSString *journalId = [[journalList[path.row] objectForKey:@"cblejJournalModel"] objectForKey:@"journalId"];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"journal/upByGradeAndlikeNum.do"];
    NSDictionary *paramDic = @{@"journalId":journalId,
                               @"likeNum":@(3),
                               @"agencysId":@(user.agencyId),
                               @"constructionId":@(self.consID),
                               @"ccConstructionNodeId":model.crNodeNumber
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞成功" controller:self sleep:1.5];

                    [self getDiaryDatawith:path];
                    
                    
                }
                    break;
                case 1001:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"节点id为空" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                case 1002:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"点赞标识为空" controller:self sleep:1.5];
                }
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                case 1004:
                    
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"已经点过赞了" controller:self sleep:1.5];
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

#pragma mark - 判断下一个节点有无权限

-(void)requestNextPointPower:(NSInteger)tag{
    if (_isDoRequest) {
        return;
    }
    _isDoRequest = YES;
    
    if (self.siteModel.ccComplete==2||self.siteModel.ccComplete==3) {
        return;
    }
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/selectJurisdiction.do"];
    NSDictionary *paramDic = @{@"cpPersonId":@(user.agencyId),
                               @"cpLimitsId":@(tag),
                               @"constructionId":@(self.consID)
                               };
//    [self.view hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
//        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    if (tag == 2010) {
                        NSInteger temJobId = [responseObj[@"cJobTypeId"] integerValue];
                        CaseMaterialController *vc = [[CaseMaterialController alloc]init];
                        vc.consID = self.consID;
                        vc.cJobTypeId = temJobId;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }else{
                        self.cJobTypeId = [responseObj[@"cJobTypeId"] integerValue];
                        
                        NodeModel *model;
                        for (NodeModel *tempmodel in self.nodeArr) {
                            if ([tempmodel.crNodeNumber integerValue]==tag) {
                                model = tempmodel;
                                break;
                            }
                        }
                        
//                        model = self.nodeArr[_nowCell-2];
                        NSInteger n = 0;
                        if (!selectNodeIsHave) {
                            n = 0;
                        }
                        else{
                            n = 1;
                        }
                        SignContractViewController *signVC = [[SignContractViewController alloc]init];
                        signVC.title = model.crRoleName;
                        signVC.constructionIdStr = self.consID;
                        signVC.cJobTypeIdStr = self.cJobTypeId;
                        signVC.type = [NSString stringWithFormat:@"%ld",tag];
                        signVC.isAdd = n;
                        signVC.index = 1;
                        signVC.nodeId = model.crNodeNumber;
                        signVC.companyId = self.companyId;
                        [self.navigationController pushViewController:signVC animated:YES];
                        //有权限
                    }
                    
                    
                }
                    
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                case 1001:
                    
                {
                    //                    isPower = NO;
                    //无权限
                    [[PublicTool defaultTool] publicToolsHUDStr:@"抱歉，你没有相关权限" controller:self sleep:1.5];
                }
                    
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                case 2000:
                    
                {
                    //                    isPower = NO;
                    [[PublicTool defaultTool] publicToolsHUDStr:@"查询错误" controller:self sleep:1.5];
                    //查询错误
                }
                    
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                    
                default:
                    break;
                    
                    
            }
            
            //            [self.diaryTableView reloadData];
            
            
            
        }

        _isDoRequest = NO;
    } failed:^(NSString *errorMsg) {
//        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        _isDoRequest = NO;
    }];
}

#pragma mark - 调用权限

-(void)requestPower:(NSString *)number{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"constructionPerson/selectJurisdiction.do"];
    NSDictionary *paramDic = @{@"cpPersonId":@(user.agencyId),
                               @"cpLimitsId":number,
                               @"constructionId":@(self.consID)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    isPower = YES;
                    self.cJobTypeId = [responseObj[@"cJobTypeId"] integerValue];
                    //有权限
                }
                    
                    ////                    NSDictionary *dic = [NSDictionary ]
                    break;
                case 1001:
                    
                {
                    isPower = NO;
                    //无权限
                }
                    
                    break;
                    
                case 2000:
                    
                {
                    isPower = NO;
                    //查询错误
                }
                    
                  
                    break;
                    
                default:
                    break;
                    
                    
            }

        }
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
}

- (void)reciveNotificationGetDiaryData:(NSNotification *)noti {

    [self getDiaryData];

}

-(void)refreshShowCell:(NSNotification *)noti{
    NSDictionary *dict = noti.userInfo;
    NSString *nodeStr = [dict objectForKey:@"node"];
    NSInteger temNode = [nodeStr integerValue];
    NSInteger temInt = 0;
//    NodeModel *node = self.nodeArr[section-2];
    for (int i = 0; i<self.nodeArr.count; i++) {
        NodeModel *model = self.nodeArr[i];
        NSInteger modelNode = [model.crNodeNumber integerValue];
        
        if (modelNode==temNode) {
            temInt = (i+2);
            break;
        }
    }
    NSString *keyStr = [NSString stringWithFormat:@"%ld",temInt];
    [_sectionDict setObject:@"1" forKey:keyStr];

    [self getDiaryDataTwo:temNode section:temInt];

}

-(void)getDiaryData{
    [self.nodeArr removeAllObjects];
    [self.caseDataArray removeAllObjects];
    [self.bannerImgArray removeAllObjects];
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getJournalDetail.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencysId":@(user.agencyId),
                               @"cityId":@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    NSArray *imgListArray = [[responseObj objectForKey:@"data"]objectForKey:@"imgList"];
                    xsFlag = [[[responseObj objectForKey:@"data"]objectForKey:@"xsFlag"] boolValue];
                    isManage = [[[responseObj objectForKey:@"data"]objectForKey:@"jingli"] boolValue];
                    isDesiger = [[[responseObj objectForKey:@"data"]objectForKey:@"shejishi"] boolValue];
                    isZManage = [[[responseObj objectForKey:@"data"]objectForKey:@"zongjingli"] boolValue];
                    implement = isZManage;
                    isOwner = [[[responseObj objectForKey:@"data"]objectForKey:@"yezhu"] boolValue];
                    if (imgListArray.count) {
                        for (NSDictionary *dict in imgListArray) {
                            [self.bannerImgArray addObject:dict[@"picUrl"]];
                        }
                    }
                    NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"material"];
                    
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                    [self.caseDataArray addObjectsFromArray:arr];
                    
                    NSArray *nodeArr = [[responseObj objectForKey:@"data"]objectForKey:@"roleList"];
                    //
                    self.cJobTypeId = [[[responseObj objectForKey:@"data"]objectForKey:@"cJobTypeId"] integerValue];
                    for (NSDictionary *dict in nodeArr) {
                        
                        NodeModel *node = [NodeModel yy_modelWithJSON:dict];
                        
                        if (![self.nodeArr containsObject:node]) {
                            [self.nodeArr addObject:node];
                        }
                    }
                    NSDictionary *construction = [[responseObj objectForKey:@"data"]objectForKey:@"construction"];
                    
                    //
                    self.siteModel = [SiteModel yy_modelWithJSON:construction];
                    isExit = [self.siteModel.isExistence boolValue];
                    [self addTwoDimensionCodeView];
                    if ([self.siteModel.ccConstructionNodeId integerValue]==2000) {
                        _nowNode = 2001;
                    }
                    else{
                        _nowNode = [self.siteModel.ccConstructionNodeId integerValue];
                    }
                    NodeModel *model;
                    for (NodeModel *temModel in self.nodeArr) {
                        if ([temModel.crNodeNumber integerValue]==_nowNode) {
                            model = temModel;
                            break;
                        }
                    }
                    
                    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                    
                    if (self.siteModel.ccComplete==0||self.siteModel.ccComplete==1) {
                        //未交工，再做判断 --- 当前节点是否有权限
                        //                        NodeModel *model = self.nodeArr[];
                        if ([model.crNodeNumber integerValue]==_nowNode) {
                            //判断当前节点我是否已经添加过
                            NSArray *arr = model.journalList;
                            if (arr.count) {
                                //1.有数据，判断自己有没有添加过
                                
                                BOOL meIsAdd = NO;
                                for (NSDictionary *dict in arr) {
                                    NSDictionary *cblejJournalModelDit = [dict objectForKey:@"cblejJournalModel"];
                                    if ([[cblejJournalModelDit objectForKey:@"agencysId"] integerValue]==user.agencyId) {
                                        
                                        meIsAdd = YES;
                                        break;
                                    }else{
                                        //
                                        meIsAdd = NO;
                                    }
                                }
                                if (meIsAdd) {
                                    //自己已添加过 不允许添加，不显示我来添加的按钮
                                    isPower = NO;
//                                    selectNodeIsHave = NO;
                                }
                                else{
                                    selectNodeIsHave = YES;
                                    //自己没添加过，根据xsFlag这个字段，判断有没有权限
                                    if (!xsFlag) {
                                        isPower = NO;
                                    }
                                    else{
                                        isPower = YES;
                                    }
                                    
                                }
                                _isFirstAdd = 1;
//                                [self.diaryTableView reloadData];
                            }else{
                                
                                selectNodeIsHave = NO;
                                //2.没数据，不用管 ，不显示我来添加的按钮
                                _isFirstAdd = 0;
                                //                                [self requestPower:model.crNodeNumber];
                                isPower = NO;
                                
//                                [self.diaryTableView reloadData];
                            }
                        }
                        else{
//                            [self.diaryTableView reloadData];
                        }
                    }
                    else{
                        //已交工 即不可以编辑也不可以添加
//                        [self.diaryTableView reloadData];
                    }
                    
                    [self.diaryTableView reloadData];
                }
                    break;
                    
                    case 2000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"获取详情失败" controller:self sleep:1.5];
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

-(void)getDiaryDataTwo:(NSInteger)tag section:(NSInteger)section{
    [self.nodeArr removeAllObjects];
    [self.caseDataArray removeAllObjects];
    [self.bannerImgArray removeAllObjects];
    [self.view hudShow];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getJournalDetail.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencysId":@(user.agencyId),
                               @"cityId":@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [self.view hiddleHud];
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    NSArray *imgListArray = [[responseObj objectForKey:@"data"]objectForKey:@"imgList"];
                    xsFlag = [[[responseObj objectForKey:@"data"]objectForKey:@"xsFlag"] boolValue];
                    isManage = [[[responseObj objectForKey:@"data"]objectForKey:@"jingli"] boolValue];
                    isDesiger = [[[responseObj objectForKey:@"data"]objectForKey:@"shejishi"] boolValue];
                    isZManage = [[[responseObj objectForKey:@"data"]objectForKey:@"zongjingli"] boolValue];
                    implement = isZManage;
                    isOwner = [[[responseObj objectForKey:@"data"]objectForKey:@"yezhu"] boolValue];
                    if (imgListArray.count) {
                        for (NSDictionary *dict in imgListArray) {
                            [self.bannerImgArray addObject:dict[@"picUrl"]];
                        }
                    }
                    NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"material"];
                    
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                    [self.caseDataArray addObjectsFromArray:arr];
                    
                    NSArray *nodeArr = [[responseObj objectForKey:@"data"]objectForKey:@"roleList"];
                    //
                    self.cJobTypeId = [[[responseObj objectForKey:@"data"]objectForKey:@"cJobTypeId"] integerValue];
                    for (NSDictionary *dict in nodeArr) {
                        
                        NodeModel *node = [NodeModel yy_modelWithJSON:dict];
                        
                        if (![self.nodeArr containsObject:node]) {
                            [self.nodeArr addObject:node];
                        }
                    }
                    NSDictionary *construction = [[responseObj objectForKey:@"data"]objectForKey:@"construction"];
                    //
                    self.siteModel = [SiteModel yy_modelWithJSON:construction];
                    if ([self.siteModel.ccConstructionNodeId integerValue]==2000) {
                        _nowNode = 2001;
                    }
                    else{
                        _nowNode = [self.siteModel.ccConstructionNodeId integerValue];
                    }
                    NodeModel *model;
                    for (NodeModel *temModel in self.nodeArr) {
                        if ([temModel.crNodeNumber integerValue]==_nowNode) {
                            model = temModel;
                            break;
                        }
                    }
                    
                    
                    
                    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                    
                    if (self.siteModel.ccComplete==0||self.siteModel.ccComplete==1) {
                        //未交工，再做判断 --- 当前节点是否有权限
                        //                        NodeModel *model = self.nodeArr[];
                        if ([model.crNodeNumber integerValue]==_nowNode) {
                            //判断当前节点我是否已经添加过
                            NSArray *arr = model.journalList;
                            if (arr.count) {
                                //1.有数据，判断自己有没有添加过
                                
                                BOOL meIsAdd = NO;
                                for (NSDictionary *dict in arr) {
                                    NSDictionary *cblejJournalModelDit = [dict objectForKey:@"cblejJournalModel"];
                                    if ([[cblejJournalModelDit objectForKey:@"agencysId"] integerValue]==user.agencyId) {
                                        
                                        meIsAdd = YES;
                                        break;
                                    }else{
                                        //
                                        meIsAdd = NO;
                                    }
                                }
                                if (meIsAdd) {
                                    //自己已添加过 不允许添加，不显示我来添加的按钮
                                    isPower = NO;
                                    //                                    selectNodeIsHave = NO;
                                }
                                else{
                                    selectNodeIsHave = YES;
                                    //自己没添加过，根据xsFlag这个字段，判断有没有权限
                                    if (!xsFlag) {
                                        isPower = NO;
                                    }
                                    else{
                                        isPower = YES;
                                    }
                                    
                                }
                                _isFirstAdd = 1;
//                                [self.diaryTableView reloadData];
                            }else{
                                
                                selectNodeIsHave = NO;
                                //2.没数据，不用管 ，不显示我来添加的按钮
                                _isFirstAdd = 0;
                                //                                [self requestPower:model.crNodeNumber];
                                isPower = NO;
                                
//                                [self.diaryTableView reloadData];
                            }
                        }
                        else{
//                            [self.diaryTableView reloadData];
                        }
                    }
                    else{
                        //已交工 即不可以编辑也不可以添加
//                        [self.diaryTableView reloadData];
                    }
                    //一个section刷新
//                    if (tag==2009){
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:10];
//                        [self.diaryTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//                    }
//                    if (tag == 2011) {
//                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:12];
//                        [self.diaryTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//                    }
//                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
//                    [self.diaryTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                    [self.diaryTableView reloadData];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        if (self.nodeArr.count>0) {
            NodeModel *model;
//            if (tag==2009) {
//                for (NodeModel *tempModel in self.nodeArr) {
//                    if ([tempModel.crNodeNumber integerValue]==tag) {
//                        model = tempModel;
//                        break;
//                    }
//                }
//                if (model.journalList.count>0) {
//                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:10];
//                    [self.diaryTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//                }
//                
//            }
//            if (tag==2011) {
//                
//                for (NodeModel *tempModel in self.nodeArr) {
//                    if ([tempModel.crNodeNumber integerValue]==tag) {
//                        model = tempModel;
//                        break;
//                    }
//                }
//                if (model.journalList.count>0) {
//                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:12];
//                    [self.diaryTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//                }
//                
//            }
            
//            for (NodeModel *tempModel in self.nodeArr) {
//                if ([tempModel.crNodeNumber integerValue]==tag) {
//                    model = tempModel;
//                    break;
//                }
//            }
//            if (model.journalList.count>0) {
//                NSInteger count = model.journalList.count;
//                NSIndexPath *path = [NSIndexPath indexPathForRow:count-1 inSection:section];
//                [self.diaryTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionMiddle];
//            }

        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
    }];
    
}

#pragma mark - 点赞之后重新刷新指定的cell
-(void)getDiaryDatawith:(NSIndexPath *)path{
    [self.nodeArr removeAllObjects];
    [self.caseDataArray removeAllObjects];
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"construction/getJournalDetail.do"];
    NSDictionary *paramDic = @{@"constructionId":@(self.consID),
                               @"agencysId":@(user.agencyId),
                               @"cityId":@""
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            YSNLog(@"%@",responseObj);
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            switch (statusCode) {
                case 1000:
                    
                {
                    NSArray *caseArr = [[responseObj objectForKey:@"data"]objectForKey:@"material"];
                    
                    NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                    [self.caseDataArray addObjectsFromArray:arr];
                    
                    NSArray *nodeArr = [[responseObj objectForKey:@"data"]objectForKey:@"roleList"];
                    //
                    self.cJobTypeId = [[[responseObj objectForKey:@"data"]objectForKey:@"cJobTypeId"] integerValue];
                    for (NSDictionary *dict in nodeArr) {
                        
                        NodeModel *node = [NodeModel yy_modelWithJSON:dict];
                        
                        if (![self.nodeArr containsObject:node]) {
                            [self.nodeArr addObject:node];
                        }
                    }
                    //一个cell刷新
//                    [self.diaryTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                    [self.diaryTableView reloadData];
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

-(UIView *)bottomV{
    if (!_bottomV) {
        _bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 44)];
        _bottomV.backgroundColor = HEX_COLOR(0xf5f5f5);
    }
    return _bottomV;
}

-(UITextView *)leaveWordTV{
    if (!_leaveWordTV) {
        _leaveWordTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, kSCREEN_WIDTH-90, 34)];
        _leaveWordTV.textColor = COLOR_BLACK_CLASS_3;
        _leaveWordTV.font = NB_FONTSEIZ_NOR;
        _leaveWordTV.delegate = self;
        _leaveWordTV.layer.masksToBounds = YES;
        _leaveWordTV.layer.cornerRadius = 4;
        

    }
    return _leaveWordTV;
}


-(UILabel *)placeholderL{
    if (!_placeholderL) {
        _placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 34)];
        _placeholderL.text = @"我也想说一句";
        _placeholderL.textColor = COLOR_BLACK_CLASS_9;
        _placeholderL.font = NB_FONTSEIZ_NOR;
    }
    return _placeholderL;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(self.leaveWordTV.right+10, self.leaveWordTV.top, 60, self.leaveWordTV.height);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = NB_FONTSEIZ_NOR;
        _sendBtn.backgroundColor = Main_Color;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 4;
        [_sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
