//
//  HomeViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeDefaultModel.h"
#import "DecorationStyleTableViewCell.h"
#import "YellowPageCompanyTableViewCell.h"
#import "YellowPageShopTableViewCell.h"
#import "SDCycleScrollView.h"
#import "MyCompanyViewController.h"
#import "CompanyDetailViewController.h"
#import "ShopDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZCHSearchViewController.h"
#import "ZCHBottomLocationPickerView.h"
#import "CompanyOutViewController.h"
#import "ZCHNewLocationController.h"
#import "ZCHCityModel.h"
#import "ZCHRightImageBtn.h"
#import "NetworkOfHomeBroadcast.h"
#import "ShopListViewController.h"
#import "CLLocation+YCLocation.h"
// 跳转到消息中心
#import "MessageCenterViewController.h"
// 设置个人中心tabbar上的角标
#import "MeViewController.h"
#import "SNNavigationController.h"
#import <UMMobClick/MobClick.h>
#import "LoginViewController.h"
#import <JPUSHService.h>
#import "WMSearchBar.h"
#import "AdvertisementWebViewController.h"
#import "SDCursorView.h"
#import "NewManagerViewController.h"
#import "NewMeViewController.h"
#import "HomeClassificationView.h"//分类View
#import "HomeClassificationModel.h"//分类Model
#import "HomeClassificationDetailViewController.h"
#import "CollectionCompanyTool.h"
#import "ComplainViewController.h"
#import "CompanyDetailNotVipController.h"
#import "HomeBroadcastView.h"
#import "HomeBroadcastListViewController.h"
#import "DistributionControlVC.h"
#import "VipGroupViewController.h"
#import "SRAudioPlayer.h"
#import "VIPExperienceShowViewController.h"
#import "BLEJBudgetTemplateController.h"
#import "SGAdvertScrollView.h"//系统消息
#import "SYNoticeBrowseLabel.h"


typedef NS_ENUM(NSInteger, UIStyle) {
    
    UIStyleBoth,
    UIStyleOnlyScroll,
    UIStyleOnlyList,
    UIStyleNone
};

//@property (nonatomic,strong)ZCHCityModel *cityModel;
//@property (nonatomic,strong)ZCHCityModel *countyModel;
ZCHCityModel *cityModel;
ZCHCityModel *countyModel;

@interface HomeViewController ()<CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate, SelectTypeDelegate, UISearchBarDelegate, SDCursorViewDelegate, YellowPageShopTableViewCellDelegate, YellowPageCompanyTableViewCellDelegate,SelectTypeDelegate,SGAdvertScrollViewDelegate> {
    CLLocationManager *_locationManager;
    CLLocationDegrees _latitude;
    CLLocationDegrees _longitude;
    SDCycleScrollView *_adScrollView;
    BOOL _firstStatus;  //是否定位成功
      BOOL  isupdateLocation;  //是否定位成功
    UISearchBar *_searchBar; //search
    UIButton *_alarmBtn;
    UILabel *_alarmLabel;
    BOOL _hasRequestDate; // 是否进行了数据请求， 防止定位时多次请求数据
    UIView *_topView;
}

@property (nonatomic, assign) UIStyle style;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *scrollImageArray;
@property (nonatomic, strong) NSMutableArray *scrollImageHrefArray;
@property (nonatomic, strong) UIView *moreView;
@property (assign, nonatomic) NSInteger pageNum;
@property (strong, nonatomic) UIImageView *defaultTopView;
@property (strong, nonatomic) SRAudioPlayer *player;
@property (strong, nonatomic) ZCHBottomLocationPickerView *bottomLocationView;
//定位按钮
@property (strong, nonatomic) ZCHRightImageBtn *locationBtn;
//选中的城市字典
@property (strong, nonatomic) NSDictionary *selectedDic;

// 显示的分类
@property (copy, nonatomic) NSString *selectType;
// 记录后台给返的数据
@property (copy, nonatomic) NSString *resultNum;
@property (strong, nonatomic) SDCursorView *cursorView;

// 类型View
//@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *viewClassification;

// 是否是内网状态
@property (nonatomic, assign) BOOL isInnerNetState;

@property (nonatomic, strong) HomeDefaultModel *shareModel;
// 底部的分享菜单
@property (strong, nonatomic) UIView *bottomShareView;
// 分享的遮罩层
@property (strong, nonatomic) UIView *shadowView;
// QQ分享
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
// 是否是定制会员
@property (nonatomic, assign) BOOL isVIP;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;
@property (nonatomic, strong) NSIndexPath *shareIndexpath;
@property (strong, nonatomic) NetworkOfHomeBroadcast *modelHomeBroadcast;
@property (strong, nonatomic) HomeBroadcastView *viewBroadcast;
@property (assign, nonatomic) CGFloat scrollViewOffSetY;

/**

 */
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (nonatomic,strong) UIView *leftimg;
@property (nonatomic,strong) SYNoticeBrowseLabel *systemLab;
//@property (nonatomic,strong)ZCHCityModel *cityModel;
//@property (nonatomic,strong)ZCHCityModel *countyModel;
@end

@implementation HomeViewController

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = @{}.mutableCopy;
    }
    return _parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelHomeBroadcast = [NetworkOfHomeBroadcast new];
//    self.cityModel=[ZCHCityModel new];
//    self.countyModel =[ZCHCityModel new];
    
    _dataArray = [[NSMutableArray alloc] init];
    _scrollImageArray = [[NSMutableArray alloc] init];
    _scrollImageHrefArray = [[NSMutableArray alloc] init];

    _isInnerNetState = NO;
    _firstStatus = NO;
    self.style = UIStyleNone;
    self.pageNum = 1;
    _hasRequestDate = NO;
    self.selectType = @"0";
    self.resultNum = @"0";
  
    [self configureUI];

    [self whetherHistoryCityExist ];

    [self getBroadcastData];
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        self.pageNum++;
        _hasRequestDate = NO;
        [self getLocationCityData];
    }];
    self.mainTableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _hasRequestDate = NO;
        self.pageNum = 1;
       [self getLocationCityData];
    }];

    [self.mainTableView.mj_header beginRefreshing];
    
    self.mainTableView.mj_footer.hidden = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData:) name:@"refreshHomeVCData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomePageWithChangingNet:) name:@"SettingChangeNet" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageNumData) name:kReciveRemoteNotification object:nil];
    // 退出登录清空消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageNum) name:klognOutNotification object:nil];
    // 退出公司清空消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageNum) name:kOutCompany object:nil];
    // 收到聊天消息 跟新消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageNumData) name:kHXUpdateMessageNumberWhenRevievedMessage object:nil];
    [self getLocation];

}
-(void)setPlayer:(SRAudioPlayer *)player{

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sound0.mp3" withExtension:nil];
    self.player = [[SRAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

-(void)whetherHistoryCityExist{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"HistoryCity"]) {
        NSString *cityname =     [[NSUserDefaults standardUserDefaults]stringForKey:@"HistoryCity"];
        [self.locationBtn setTitle:cityname forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.systemLab releaseNotice];
    [MobClick endLogPageView:@"企业"];
    if (self.bottomLocationView.hidden == NO) {
        self.bottomLocationView.hidden = YES;
    }
    self.moreView.hidden = YES;
    [_searchBar endEditing:YES];
    
   
}
#pragma mark --  计算器版本升级只是该版本通知一次,上线前要修改改版本号
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getMessageNumData];
    [MobClick beginLogPageView:@"企业"];
    [MobClick event:@"AppYellowPage"];

    // 测试打开下面一句[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"calculateVersionUpAlart"];

    BOOL isAlart = [[NSUserDefaults standardUserDefaults] boolForKey:@"calculateVersionUpAlart"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];

    if ([version isEqualToString:kCalculateVersionUp] && !isAlart && isLogin) {

        NSString *requestStr = [BASEURL stringByAppendingString:@"user/getChangeCompareVersion.do"];
        [NetManager afGetRequest:requestStr parms:nil finished:^(id responseObj) {
            if ([responseObj[@"code"] integerValue] == 1000) {
                NSDictionary *dict = responseObj[@"data"];
                NSString *version = dict[@"version"];
                if ([version isEqualToString:@"4.2.0"]) {
                    [[[TTAlertView alloc] initWithTitle:@"计算器功能升级通知" message:@"计算器功能升级，与旧版本相差较大，如果您已经设置了计算器模板，为了不影响正常使用，请进入我的公司重新设置计算器模板；如果不更新设置，可能会影响旧版本使用。" clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    } cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];

                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"calculateVersionUpAlart"];
                }
            }

        } failed:^(NSString *errorMsg) {

        }];
    }
    [self getBroadcastData];
}
#pragma mark Views

- (void)configureUI {

    self.edgesForExtendedLayout = UIRectEdgeNone;
    // 修改导航栏字体颜色及字体大小
    [self setUpRightBarButtonItem];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]}];
    self.view.backgroundColor = Bottom_Color;

    [self makeHeaderView];
    [self addTabelView];



    self.locationBtn = [[ZCHRightImageBtn alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [self.locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.locationBtn.myFont = AdaptedFontSize(14);

    [self.locationBtn setTitle:@"定位中..." forState:UIControlStateNormal];
    [self.locationBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    [self.locationBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.locationBtn];
    self.navigationItem.leftBarButtonItem = barItem;

    if ([[[UIDevice currentDevice] systemVersion] floatValue]  >= 11.0) {

        self.definesPresentationContext = YES;
        WMSearchBar *searchBar = [[WMSearchBar alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 80 - 44 - 2 * 15, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = @"搜索商家品类或店铺";
        searchBar.backgroundImage = [UIImage new];
        searchBar.backgroundColor = [UIColor clearColor];

        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 30.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);

        UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
        [wrapView addSubview:searchBar];
        self.navigationItem.titleView = wrapView;
    } else {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(80, 0, 50, 44)];
        _searchBar.placeholder = @"搜索商家品类或店铺";
        _searchBar.delegate = self;
        
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = _searchBar;
    }
}

- (UIView *)viewClassification {
    if (!_viewClassification) {
        CGFloat VCFW = kSCREEN_WIDTH/5;
        CGFloat VCFH = VCFW * 1.5 + VCFW;
        _viewClassification = [UIView new];
        _viewClassification.frame = CGRectMake(0, kSCREEN_WIDTH * 0.6+16, kSCREEN_WIDTH, VCFH);
        [HomeClassificationModel.arrayTitle enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HomeClassificationView *viewClassification = [[[NSBundle mainBundle] loadNibNamed:@"HomeClassificationView" owner:self options:nil] lastObject];
            viewClassification.tag = idx;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTypeBtn:)];
            [viewClassification addGestureRecognizer:tap];
            viewClassification.frame = CGRectMake(VCFW*idx, 0, VCFW, VCFW * 1.5);
            [_viewClassification addSubview:viewClassification];
            [viewClassification.imageViewIcon setImage:[UIImage imageNamed:HomeClassificationModel.arrayIcon[idx]]];
            [viewClassification.labelTitle setText:HomeClassificationModel.arrayTitle[idx]];
        }];
        [_viewClassification addSubview:self.viewBroadcast];
        
     
    }
    return _viewClassification;
}

- (HomeBroadcastView *)viewBroadcast {
    if (!_viewBroadcast) {
        WeakSelf(self)
        _viewBroadcast = [[[NSBundle mainBundle] loadNibNamed:@"HomeBroadcastView" owner:self options:nil] lastObject];
        [_viewBroadcast setBackgroundColor:[UIColor clearColor]];
        _viewBroadcast.blockDidtouchLabel = ^{
            HomeBroadcastListViewController *controller = [HomeBroadcastListViewController new];
            [controller.view setBackgroundColor:[UIColor whiteColor]];
            [weakself.navigationController pushViewController:controller animated:true];
        };
        _viewBroadcast.frame = CGRectMake(0, kSCREEN_WIDTH/5 * 1.5, kSCREEN_WIDTH, kSCREEN_WIDTH/5);
        [_viewBroadcast setBackgroundColor:[UIColor whiteColor]];
    }
    return _viewBroadcast;
}

- (void)makeHeaderView {
    /*在tableview之前添加一个view 上面包含了scrollView轮动图，家装分类列表和翻滚播报视图，topview没有用layOut创建*/
    CGFloat VCFW = kSCREEN_WIDTH/5;
    CGFloat VCFH = VCFW * 1.5 + VCFW;
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6 + VCFH+18)];
    self.defaultTopView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6 + VCFH)];
    self.defaultTopView.hidden = YES;
    [_topView addSubview:self.defaultTopView];
    
    _adScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.6) delegate:self placeholderImage:nil];
    _adScrollView.autoScrollTimeInterval = BANNERTIME;
    _adScrollView.hidden = YES;
    _adScrollView.backgroundColor = [UIColor blackColor];
    _adScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _adScrollView.imageURLStringsGroup = _scrollImageArray;
    [_topView addSubview:_adScrollView];

    
    [_topView addSubview:self.viewClassification];
    self.viewClassification.backgroundColor = White_Color;
    _topView.backgroundColor = White_Color;
    
    //这个地方莫名其妙的多了一条线，加一个view给挡住
    UIView *bgview = [UIView new];
    bgview.backgroundColor = [UIColor whiteColor];
    bgview.frame = CGRectMake(0, kSCREEN_WIDTH*0.6, kSCREEN_WIDTH, 22);
    [_topView addSubview:bgview];
    
    self.leftimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_laba"]];
    self.leftimg.frame = CGRectMake(7, kSCREEN_WIDTH*0.6+2, 14, 14);
    [_topView addSubview:self.leftimg];
    
    self.systemLab = [[SYNoticeBrowseLabel alloc] initWithFrame:CGRectMake(21, self.leftimg.top, kSCREEN_WIDTH-24, 14)];
    self.systemLab.browseMode = SYNoticeBrowseHorizontalScrollWhileSingle;
    [_topView addSubview:self.systemLab];
    self.systemLab.tag = 1000;
    self.systemLab.backgroundColor = White_Color;
    self.systemLab.textColor = [UIColor blackColor];
    self.systemLab.textFont = [UIFont systemFontOfSize:13.0];
    self.systemLab.textClick = ^(NSInteger index){
       
    };
    self.systemLab.durationTime = 3.0;
    self.systemLab.delayTime = 3.0;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

-(void)setsystemlabarr:(NSMutableArray *)arr
{
    NSMutableArray *dataSource = [NSMutableArray new];
    for (NSDictionary *dic in arr) {
        NSString *news = [dic objectForKey:@"content"];
        [dataSource addObject:news];
    }
    self.systemLab.texts = dataSource;
    self.systemLab.titleColor = [UIColor hexStringToColor:@"666666"];
    self.systemLab.titleFont = [UIFont systemFontOfSize:13];
    [self.systemLab reloadData];
}

-(void)addTabelView{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_mainTableView];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    self.mainTableView.tableHeaderView = _topView;
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 20)];

}
- (void)setUpRightBarButtonItem {
    // 设置导航栏最右侧的按钮
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion floatValue] >= 11.0) {

        _alarmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _alarmBtn.frame = CGRectMake(0, 0, 44, 44);
        [_alarmBtn setImage:[UIImage imageNamed:@"alarm"] forState:UIControlStateNormal];
        [_alarmBtn setImage:[UIImage imageNamed:@"alarm"] forState:UIControlStateHighlighted];
        _alarmBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_alarmBtn addTarget:self action:@selector(alarmBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_alarmBtn];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(36, 4, 16, 16)];
        _alarmLabel = label;
        [_alarmBtn addSubview:label];
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.hidden = YES;

    } else {
        _alarmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _alarmBtn.frame = CGRectMake(0, 0, 44, 44);
        [_alarmBtn setImage:[UIImage imageNamed:@"alarm"] forState:UIControlStateNormal];
        [_alarmBtn setImage:[UIImage imageNamed:@"alarm"] forState:UIControlStateHighlighted];
        _alarmBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
        [_alarmBtn addTarget:self action:@selector(alarmBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_alarmBtn];

        UILabel *label = [UILabel new];
        _alarmLabel = label;
        [_alarmBtn addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(10);
            make.top.mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        label.layer.cornerRadius = 8;
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.hidden = YES;
    }
}


- (void)alarmBtnClickAction:(UIButton *)sender {
    // 如果没有登录跳转到登录页面
    BOOL _isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (_isLogined == YES) {
        self.tabBarController.selectedIndex = 2;
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - 获取消息数量
- (void)getMessageNumData {

    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{

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
                dispatch_async(dispatch_get_main_queue(), ^{

                    NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
                    if (code == 1000) {
                        NSDictionary *numDic = [responseObj objectForKey:@"data"];
                        NSMutableArray *numArray = [NSMutableArray array];
                        // 计算器报价消息数量
                        NSInteger calCount = [numDic[@"calCount"] integerValue];
                        [numArray addObject:@(calCount)];
                        //客户预约
                        NSInteger callDeco = [numDic[@"callDeco"] integerValue];
                        [numArray addObject:@(callDeco)];

                        //报名活动
                        NSInteger signupMessageNum = [numDic[@"signupMessageNum"] integerValue];
                        [numArray addObject:@(signupMessageNum)];
                        //公司申请
                        NSInteger companyApply = [numDic[@"companyApply"] integerValue];
                        [numArray addObject:@(companyApply)];
                        //联盟邀请
                        NSInteger invatationSum = [numDic[@"invatationSum"] integerValue];
                        [numArray addObject:@(invatationSum)];
                        //联盟申请
                        NSInteger unionApplyNum = [numDic[@"unionApplyNum"] integerValue];
                        [numArray addObject:@(unionApplyNum)];
                        // 合作企业
                        NSInteger enterPriseCount = [numDic[@"enterPriseCount"] integerValue];
                        [numArray addObject:@(enterPriseCount)];
                        //同城发布
                        NSInteger citywideMessage = [numDic[@"citywideMessage"] integerValue];
                        [numArray addObject:@(citywideMessage)];

                        //关注消息数量
                        NSInteger attentionMessageSum = [numDic[@"attentionMessageSum"]integerValue];
                        [numArray addObject:@(attentionMessageSum)];

                        NSInteger totalNum = 0;


                        for (int i = 0; i < numArray.count; i ++) {
                            totalNum += [numArray[i] integerValue];

                        }
                        _alarmLabel.hidden = totalNum == 0;

                        if (totalNum > 99) {
                            [_alarmLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.right.mas_equalTo(10);
                                make.top.mas_equalTo(5);
                                make.size.mas_equalTo(CGSizeMake(28, 16));
                            }];
                            _alarmLabel.text = @"99+";
                        } else if (totalNum > 9) {
                            [_alarmLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.right.mas_equalTo(5);
                                make.top.mas_equalTo(5);
                                make.size.mas_equalTo(CGSizeMake(22, 16));
                            }];
                            _alarmLabel.text = [NSString stringWithFormat:@"%ld", (long)totalNum];
                        } else {
                            [_alarmLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.right.mas_equalTo(10);
                                make.top.mas_equalTo(5);
                                make.size.mas_equalTo(CGSizeMake(16, 16));
                            }];
                            _alarmLabel.text = [NSString stringWithFormat:@"%ld", (long)totalNum];
                        }
                        NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)totalNum];
                        SNNavigationController *navi = self.tabBarController.viewControllers[2];
                        NewManagerViewController *newManagerVC = navi.viewControllers[0];

                        if (totalNum > 99) {
                            newManagerVC.tabBarItem.badgeValue = @"99+";
                        } else if (totalNum > 0) {
                            newManagerVC.tabBarItem.badgeValue = messageNUMStr;
                        } else {
                            newManagerVC.tabBarItem.badgeValue = nil;
                        }


                        // 个人中心有系统消息 和 使用说明提示
                        NSInteger systemNum = [numDic[@"complain"] integerValue];
                        // 所有消息总数
                        NSInteger allNum = [numDic[@"total"] integerValue];

                        // 消息数量添加 使用说明提示
                        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                        if (kHasUseExpalinUpdate && !isReade) {
                            systemNum += 1;
                            allNum += 1;
                        }
                        NSString *systemNUMStr = [NSString stringWithFormat:@"%ld", (long)systemNum];
                        SNNavigationController *meNavi = self.tabBarController.viewControllers[3];
                        NewMeViewController *newMeVC = meNavi.viewControllers[0];

                        if (systemNum > 99) {
                            newMeVC.tabBarItem.badgeValue = @"99+";
                        } else if (systemNum > 0) {
                            newMeVC.tabBarItem.badgeValue = systemNUMStr;
                        } else {
                            newMeVC.tabBarItem.badgeValue = nil;
                        }


                        [UIApplication sharedApplication].applicationIconBadgeNumber = allNum;
                        if (allNum == 0) {
                            [JPUSHService resetBadge];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTabBarItemBadageValueChange" object:nil];
                    }
                });

            } failed:^(NSString *errorMsg) {

                dispatch_async(dispatch_get_main_queue(), ^{
                    //加载失败
                    [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
                });
            }];

        });

    } else {
        // 消息数量添加 使用说明提示
        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
        if (kHasUseExpalinUpdate && !isReade) {
            SNNavigationController *navi = self.tabBarController.viewControllers[3];
            NewMeViewController *meVC = navi.viewControllers[0];
            meVC.tabBarItem.badgeValue = @"1";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        } else {
            SNNavigationController *navi = self.tabBarController.viewControllers[3];
            MeViewController *meVC = navi.viewControllers[0];
            meVC.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        // 云管理的
        SNNavigationController *navi = self.tabBarController.viewControllers[2];
        NewManagerViewController *newManagerVC = navi.viewControllers[0];
        newManagerVC.tabBarItem.badgeValue = nil;
    }
}

// 清空消息
- (void)clearMessageNum {

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    UIImage *image = [UIImage imageNamed:@"alarm"];
    [_alarmBtn setImage:image forState:UIControlStateNormal];
    _alarmLabel.text = 0;
    _alarmLabel.hidden = YES;

    //  个人中心的 消息数量添加 使用说明提示
    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
    if (kHasUseExpalinUpdate && !isReade) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        SNNavigationController *navi = self.tabBarController.viewControllers[3];
        NewMeViewController *meVC = navi.viewControllers[0];
        meVC.tabBarItem.badgeValue = @"1";
    }
    // 云管理的
    SNNavigationController *navi = self.tabBarController.viewControllers[2];
    NewManagerViewController *newManagerVC = navi.viewControllers[0];
    newManagerVC.tabBarItem.badgeValue = nil;

}

#pragma mark  调起城市选择
- (void)selectCity {
    
    self.moreView.hidden = YES;
    ZCHNewLocationController *locationVC = [[ZCHNewLocationController alloc] init];
    __weak typeof(self) weakSelf = self;
    locationVC.refreshBlock = ^(NSDictionary *modelDic) {

        [weakSelf.locationBtn setTitle:[modelDic objectForKey:@"name"]?:@"" forState:normal];
        self.pageNum = 1;
        _hasRequestDate = NO;
        self.resultNum  = @"0";
        cityModel.cityId = [modelDic objectForKey:@"cityId"];
        [weakSelf getLocationCityData];
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    CLLocationDegrees tempLongitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLongitude"] doubleValue];
    CLLocationDegrees tempLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLatitude"] doubleValue];
    _longitude = tempLongitude ? tempLongitude : 40.000000;
    _latitude = tempLatitude ? tempLatitude :116.000000;
    [[NSUserDefaults standardUserDefaults] setObject:@(116) forKey:@"YPLatitude"];
    [[NSUserDefaults standardUserDefaults] setObject:@(40) forKey:@"YPLongitude"];
    [self getLocationCityData];
}

#pragma mark - 店铺分类的跳转事件
- (void)pushShopListVc:(UIButton *)btn {

    ShopListViewController *shopListVC = [[ShopListViewController alloc] init];
    shopListVC.origin = @"0";
    shopListVC.latitude = [NSString stringWithFormat:@"%f",_latitude];
    shopListVC.longititude = [NSString stringWithFormat:@"%f",_longitude];

    switch (btn.tag) {
        case 0:
            [MobClick event:@"GuanGaoPaiBian"];
            shopListVC.type = 1012;
            shopListVC.titleStr = @"广告牌匾";
            break;
        case 1:
            [MobClick event:@"JiaZhengBaoJie"];
            shopListVC.type = 1013;
            shopListVC.titleStr = @"家政保洁";
            break;
        case 2:
            [MobClick event:@"BanJia"];
            shopListVC.type = 1014;
            shopListVC.titleStr = @"搬家";
            break;
        case 3:
            [MobClick event:@"KongQiZhiLi"];
            shopListVC.type = 1015;
            shopListVC.titleStr = @"空气治理";
            break;
        case 4:
            [MobClick event:@"CiZhuanMeiFeng"];
            shopListVC.type = 1016;
            shopListVC.titleStr = @"瓷砖美缝";
            break;
        case 5:
            [MobClick event:@"RuanBaoShaChuang"];
            shopListVC.type = 1017;
            shopListVC.titleStr = @"软包纱窗";
            break;
        case 6:
            [MobClick event:@"ZhiNengJiaJu"];
            shopListVC.type = 1019;
            shopListVC.titleStr = @"智能家居";
            break;
        case 7:
            shopListVC.type = 1020;
            shopListVC.titleStr = @"房产中介";
            break;
        case 8:
            [MobClick event:@"QiTa"];
            shopListVC.type = 1010;
            shopListVC.titleStr = @"其他";
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:shopListVC animated:YES];
}

#pragma mark - tableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return _isInnerNetState ? 0 : 1;
        //        return 1;
    } else {

        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (_style) {
        case UIStyleBoth:
        {
            if (indexPath.section == 0) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 0)];
                return cell;
            } else if (indexPath.section == 1) {
                HomeDefaultModel *model = _dataArray[indexPath.row];
                cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageCompanyTableViewCell class]) owner:self options:nil] lastObject];
                }
                //0:距离,-1好评,-2信用,2浏览,1:案例,5:商品
                ((YellowPageCompanyTableViewCell*)cell).cellType = self.selectType.integerValue;
                ((YellowPageCompanyTableViewCell*)cell).delegate = self;
                ((YellowPageCompanyTableViewCell*)cell).model = model;
                return cell;
            } else return [UITableViewCell new];;
        }
            break;
        case UIStyleOnlyList:
        {
            if (indexPath.section == 0) {

                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 0)];
                //                [cell.contentView addSubview:self.viewClassification];
                return cell;
            } else if (indexPath.section == 1) {
                HomeDefaultModel *model = _dataArray[indexPath.row];
                cell = [tableView dequeueReusableCellWithIdentifier:@"company"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YellowPageCompanyTableViewCell class]) owner:self options:nil] lastObject];
                }
                //0:距离,-1好评,-2信用,2浏览,1:案例,5:商品
                ((YellowPageCompanyTableViewCell*)cell).cellType = self.selectType.integerValue;
                ((YellowPageCompanyTableViewCell*)cell).delegate = self;
                ((YellowPageCompanyTableViewCell*)cell).model = model;
                return cell;
            } else return [UITableViewCell new];
        }
            break;
        case UIStyleOnlyScroll:
        {

            if (indexPath.section == 0) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 0)];
              
                return cell;
            }else return [UITableViewCell new];;
        }
            break;
        case UIStyleNone:
        {

            if (indexPath.section == 0) {
                cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 0)];
                
                return cell;
            }else return [UITableViewCell new];
        }
            break;
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            return cell;
            break;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.bottomLocationView.hidden == NO) {
        self.bottomLocationView.hidden = YES;
    }
    self.moreView.hidden = YES;
    [_searchBar endEditing:YES];

    if (indexPath.section == 1) {

        HomeDefaultModel *model = [_dataArray objectAtIndex:indexPath.row];
        if ([model.vipState isEqualToString:@"1"]) {
            //公司的详情
            if ([model.companyType isEqualToString:@"1018"]||[model.companyType isEqualToString:@"1064"]||[model.companyType isEqualToString:@"1065"]) {

                CompanyDetailViewController *company = [[CompanyDetailViewController alloc] init];
                company.HomeModel =model;
                company.cityId = cityModel.cityId;
                company.countyId = countyModel ? countyModel.cityId : @"0";
                company.companyName = model.typeName;
                company.companyID = model.shopID;
                model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
                model.displayNumbers = [NSString stringWithFormat:@"%ld", model.displayNumbers.integerValue + 1];
                company.hidesBottomBarWhenPushed = YES;
                company.notVipButHaveArticle = NO;
                company.origin = @"0";
                [self.navigationController pushViewController:company animated:YES];
            } else {
                //店铺的详情;
                ShopDetailViewController *shop = [[ShopDetailViewController alloc] init];
                shop.shopName = model.typeName;
                shop.homeModel =model;
                shop.shopID = model.shopID;
                model.browse = [NSString stringWithFormat:@"%ld", model.browse.integerValue + 1];
                model.displayNumbers = [NSString stringWithFormat:@"%ld", model.displayNumbers.integerValue + 1];
                shop.hidesBottomBarWhenPushed = YES;
                shop.notVipButHaveArticle = NO;
                shop.origin = @"0";
                [self.navigationController pushViewController:shop animated:YES];
            }
        } else {
            VIPExperienceShowViewController *controller = [VIPExperienceShowViewController new];
            controller.isEdit = false;
            controller.companyId = model.shopID;
            controller.origin = @"0";
            [self.navigationController pushViewController:controller animated:true];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (_style == UIStyleOnlyScroll || _style == UIStyleBoth) {
        if (section == 0 && _adScrollView) {

            self.defaultTopView.hidden = YES;
            _adScrollView.hidden = NO;

            return nil;
        } else if (section == 1) {
            if (self.isInnerNetState) {
                UIView *v = [UIView new];
                v.backgroundColor = kBackgroundColor;
                return v;
            }
            if (self.cursorView == nil) {
                NSArray *titles = @[@"距离", @"好评", @"信用", @"综合▼"];
                SDCursorView *cursorView = [[SDCursorView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)];
                //设置控件所在controller
                cursorView.parentViewController = self;
                cursorView.titles = titles;
                //设置字体和颜色
                cursorView.normalColor = [UIColor blackColor];
                cursorView.selectedColor = [UIColor blackColor];
                if (IPhone4) {
                    cursorView.selectedFont = [UIFont systemFontOfSize:14];
                    cursorView.normalFont = [UIFont systemFontOfSize:12];
                } else if (IPhone5) {
                    cursorView.selectedFont = [UIFont systemFontOfSize:15];
                    cursorView.normalFont = [UIFont systemFontOfSize:13];
                } else {
                    cursorView.selectedFont = [UIFont systemFontOfSize:17];
                    cursorView.normalFont = [UIFont systemFontOfSize:15];
                }
                cursorView.backgroundColor = kBackgroundColor;
                cursorView.delegate = self;
                cursorView.lineView.backgroundColor = kMainThemeColor;
                self.cursorView = cursorView;
                //属性设置完成后，调用此方法绘制界面
                [cursorView reloadPages];
            }
            return self.cursorView;
        } else return nil;

    } else if (section == 0) {

        _adScrollView.hidden = YES;
        self.defaultTopView.hidden = NO;
        return nil;
    } else if (section == 1) {
        if (_isInnerNetState) {
            UIView *v = [UIView new];
            v.backgroundColor = kBackgroundColor;
            return v;
        }
        if (self.cursorView == nil) {

            NSArray *titles = @[@"距离", @"好评", @"信用", @"综合▼"];
            SDCursorView *cursorView = [[SDCursorView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, 40)];
            //设置控件所在controller
            cursorView.parentViewController = self;
            cursorView.titles = titles;
            //设置字体和颜色
            cursorView.normalColor = [UIColor blackColor];
            cursorView.selectedColor = [UIColor blackColor];
            if (IPhone4) {
                cursorView.selectedFont = [UIFont systemFontOfSize:14];
                cursorView.normalFont = [UIFont systemFontOfSize:12];
            } else if (IPhone5) {
                cursorView.selectedFont = [UIFont systemFontOfSize:15];
                cursorView.normalFont = [UIFont systemFontOfSize:13];
            } else {
                cursorView.selectedFont = [UIFont systemFontOfSize:17];
                cursorView.normalFont = [UIFont systemFontOfSize:15];
            }
            cursorView.backgroundColor = [UIColor whiteColor];
            cursorView.delegate = self;
            cursorView.lineView.backgroundColor = kMainThemeColor;
            //属性设置完成后，调用此方法绘制界面
            [cursorView reloadPages];
            self.cursorView = cursorView;
        }
        return self.cursorView;
    }

    return nil;
}


- (void)didClickShareContentBtn:(UIButton *)btn {
    
    NSString *shareTitle = self.shareModel.typeName;
    NSString *shareDescription = self.shareModel.companyIntroduction;
    if (shareDescription.length > 30) {
        shareDescription = [shareDescription substringToIndex:28];
    }

    UIImage *shareImage;
    NSData *shareData;


    YellowPageShopTableViewCell *cell = [_mainTableView cellForRowAtIndexPath:self.shareIndexpath];
    shareImage = cell.companyLogo.image;

    NSData *data=UIImageJPEGRepresentation(shareImage, 1.0);
    if (data.length > 32) {
        UIGraphicsBeginImageContext(CGSizeMake(300, 300));
        [shareImage drawInRect:CGRectMake(0,0,300,300)];
        shareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGFloat scale = 32.0 / data.length;
        shareData  = UIImageJPEGRepresentation(shareImage, scale);

    }

    [self addTwoDimensionCodeView];
    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm", self.shareModel.shopID]];
    switch (btn.tag) {
        case 0:
        {// 微信好友
            WXMediaMessage *message = [WXMediaMessage message];

            message.title = shareTitle;
            message.description = shareDescription;
            [message setThumbImage:shareImage];

            WXWebpageObject *webPageObject = [WXWebpageObject object];
 
            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;

            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneSession;

            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopListShare"];
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
            [message setThumbImage:shareImage];
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];

            webPageObject.webpageUrl = shareURL;
            message.mediaObject = webPageObject;

            SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;

            BOOL isSend = [WXApi sendReq:req];
            if (isSend) {
                [MobClick event:@"ShopListShare"];
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
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface sendReq:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopListShare"];
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
                NSURL *url = [NSURL URLWithString:shareURL];
                QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:shareTitle description:shareDescription previewImageData:shareData];
                //向QQ发送消息，查看是否可以发送
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
                QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
                YSNLog(@"%d",code);
                if (code == 0) {
                    [MobClick event:@"ShopListShare"];
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
        {// 二维码
            [MobClick event:@"ShopListShare"];
            self.TwoDimensionCodeView.hidden = NO;
            self.shadowView.hidden = YES;
            self.bottomShareView.blej_y = BLEJHeight;
            [UIView animateWithDuration:0.25 animations:^{

                self.TwoDimensionCodeView.alpha = 1.0;
                self.navigationController.navigationBar.alpha = 0;
            }];
        }
            break;
        default:
            break;
    }
    // 统计公司分享数量
    [NSObject companyShareStatisticsWithConpanyId:self.shareModel.shopID];
}

// 点击二维码图片后生成的分享页面
- (void)addTwoDimensionCodeView {

    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    //    [self.view sendSubviewToBack:self.tableView];
    self.TwoDimensionCodeView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickTwoDimensionCodeView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];

    UIImageView *codeView = [[UIImageView alloc] init];
    codeView.size = CGSizeMake(BLEJWidth - 40, BLEJWidth - 40);
    codeView.center = self.TwoDimensionCodeView.center;
    codeView.backgroundColor = [UIColor whiteColor];
    [self.TwoDimensionCodeView addSubview:codeView];

    NSString *shareURL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/store/%@.htm", self.shareModel.shopID]];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        UIImage *shareImage;
        YellowPageShopTableViewCell * cell = [_mainTableView cellForRowAtIndexPath:self.shareIndexpath];
        shareImage = cell.companyLogo.image;
        shareImage = [UIImage imageWithData:[NSObject imageWithImage:shareImage scaledToSize:CGSizeMake(300, 300)]];

        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:shareImage logoScaleToSuperView:0.25];

        });
    });

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"截屏保存到相册:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    [self.TwoDimensionCodeView addSubview:label];

    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    labelBottom.textColor = [UIColor darkGrayColor];
    labelBottom.textAlignment = NSTextAlignmentCenter;
    labelBottom.font = [UIFont systemFontOfSize:16];
    [self.TwoDimensionCodeView addSubview:labelBottom];

    UILabel *titleLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(codeView.mas_top).equalTo(-20);
        make.left.right.equalTo(0);
    }];
    titleLabel.text = @"名片";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blackColor];

    UILabel *companyNameLabel = [[UILabel alloc] init];
    [self.TwoDimensionCodeView addSubview:companyNameLabel];
    [companyNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleLabel.mas_top).equalTo(-10);
        make.left.equalTo(codeView).equalTo(6);
        make.right.equalTo(codeView).equalTo(-6);
    }];
    YellowPageShopTableViewCell * cell = [_mainTableView cellForRowAtIndexPath:self.shareIndexpath];
    NSString *companyName = cell.companyNameLabel.text;
    companyNameLabel.text = companyName;
    companyNameLabel.textAlignment = NSTextAlignmentCenter;
    companyNameLabel.numberOfLines = 0;
    companyNameLabel.font = [UIFont systemFontOfSize:20];
    companyNameLabel.textColor = [UIColor blackColor];

    self.TwoDimensionCodeView.hidden = YES;
}

- (void)didClickTwoDimensionCodeView:(UITapGestureRecognizer *)tap {

    [UIView animateWithDuration:0.25 animations:^{

        self.TwoDimensionCodeView.alpha = 0;
        self.navigationController.navigationBar.alpha = 1;
    }completion:^(BOOL finished) {

        self.TwoDimensionCodeView.hidden = YES;
    }];
}

#pragma mark  分享 ↑

#pragma mark - SDCursorViewDelegate点击分类菜单的事件
- (void)didClickMenuWithIndex:(NSInteger)index {
    if (index == 3) {//综合
        CGFloat VCFW = kSCREEN_WIDTH/5;
        CGFloat VCFH = VCFW * 1.5 + VCFW;
        PellTableViewSelect *selectView = [PellTableViewSelect sharedInstance];
        [selectView addViewWithFrame:CGRectMake(0, kSCREEN_WIDTH * 0.6 + VCFH + kNaviHeight - self.scrollViewOffSetY + 40, kSCREEN_WIDTH, 120) selectData:@[@"浏览多", @"案例多", @"商品多"] images:nil selectIndex:self.selectType.integerValue action:^(NSInteger index) {
            if (index == 0) {
                self.selectType = @"2";
            }else if (index == 1) {
                self.selectType = @"1";
            }else if (index == 2) {
                self.selectType = @"5";
            }
            _hasRequestDate = false;
            [self getLocationCityData];
        } animated:false];
        selectView.blockDidTouchBG = ^(NSInteger index) {
            self.cursorView.currentIndex = 0;
            [self.cursorView reloadPages];
        };
    }else{
        // type: 排序类型 self.selectType
        self.selectType = [NSString stringWithFormat:@"%ld", 0 - index];
    }
    self.resultNum = @"0";
    self.pageNum = 1;
    _hasRequestDate = NO;
    [self getLocationCityData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {

        //        return kSCREEN_WIDTH * 0.6;
        return 0.001;
    } else if (section == 1) {
        return _isInnerNetState ? 10 : 40;
        //        return 40;
    } else return 0.0001f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0;
    } else if (indexPath.section == 1) {
        return 100;
    } else {
        return 0;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.bottomLocationView.hidden == NO) {
        self.bottomLocationView.hidden = YES;
    }
    self.moreView.hidden = YES;
    [_searchBar endEditing:YES];
    CGPoint offset = scrollView.contentOffset;
    self.scrollViewOffSetY = offset.y;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    ZCHSearchViewController *searchVC = [[ZCHSearchViewController alloc] init];
    searchVC.parameters = self.parameters;
    searchVC.origin = @"0";
    [self.navigationController pushViewController:searchVC animated:YES];
    return NO;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSString *webUrl = self.scrollImageHrefArray[index]; //self.topImageDicArray[index][@"picHref"];

    if (webUrl.length > 0) {
        if (![webUrl ew_isUrlString]) {
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
            return;
        }
        if ([webUrl isEqualToString:@"http://testapi.bilinerju.com/resources/html/huiyuanchangtu.html"] || [webUrl isEqualToString:@"http://api.bilinerju.com/resources/html/huiyuanchangtu.html"]) {
            VipGroupViewController *controller = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
            controller.isFromNotVipYellow = false;
            [self.navigationController pushViewController:controller animated:true];
        }else{
            AdvertisementWebViewController *adWebViewVC = [[AdvertisementWebViewController alloc] init];
            adWebViewVC.webUrl = webUrl;
            [self.navigationController pushViewController:adWebViewVC animated:YES];
        }
    }
}

#pragma mark - 通知处理 刷新页面(登录或者登出或者从二级页面传出来的)
- (void)reloadAllData:(NSNotification *)noc {
    [self.locationBtn setTitle:countyModel ? countyModel.name : cityModel.name forState:UIControlStateNormal];
    self.pageNum = 1;
    _hasRequestDate = NO;
    self.resultNum  = @"0";
    [self getLocation];
}

#pragma mark - 切换网络需要重新刷新页面
- (void)refreshHomePageWithChangingNet:(NSNotification *)noc {

    [self.locationBtn setTitle:countyModel ? countyModel.name : cityModel.name forState:UIControlStateNormal];
    self.pageNum = 1;
    _hasRequestDate = NO;
    self.resultNum  = @"0";
    [self getLocation];
}

#pragma mark - 定位相关
- (void)getLocation {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status ==kCLAuthorizationStatusAuthorizedAlways) {
        
        [_locationManager startUpdatingLocation];
        
    }
    if (status == kCLAuthorizationStatusDenied || status ==kCLAuthorizationStatusNotDetermined) {
        _longitude = 40.000000;
        _latitude = 116.000000;
        [self getLocationCityData];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (isupdateLocation) {
        [self getLocationCityData];
        return;
    }
    isupdateLocation=YES;
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    currentLocation = [currentLocation locationMarsFromEarth];
    currentLocation = [currentLocation locationBaiduFromMars];
    if (currentLocation) {
        _latitude = currentLocation.coordinate.latitude;
        _longitude = currentLocation.coordinate.longitude;
        [[NSUserDefaults standardUserDefaults] setObject:@(_latitude) forKey:@"YPLatitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@(_longitude) forKey:@"YPLongitude"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [self getLocationCityData];
    //[self.mainTableView.mj_header beginRefreshing];
}

#pragma mark - 获取用户当前所处的地级市 获取数据
- (void)getLocationCityData {
    
  
    
    if (_hasRequestDate) {
        return;
    }
    _hasRequestDate = YES;

    if (self.pageNum == 1) {
        self.mainTableView.mj_footer.state = MJRefreshStateIdle;
    }

    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {

        agencyid = 0;
    }

    NSString *api = [BASEURLWX stringByAppendingString:@"company/getCompanyByMap.do"];
    NSMutableDictionary *param=[NSMutableDictionary dictionary];
    //0:距离,-1好评,-2信用,2浏览,1:案例,5:商品
    
    CLLocationDegrees tempLongitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLongitude"] doubleValue];
    CLLocationDegrees tempLatitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"YPLatitude"] doubleValue];
    
    //id cityid  =  [[NSUserDefaults standardUserDefaults]objectForKey:@"HistoryCityId"];
    
    id cityid = cityModel.cityId;
    
    [param setObject:[NSNumber numberWithDouble:_latitude]?: [NSNumber numberWithDouble:tempLatitude]
              forKey: @"latitude" ];
    [param setObject:[NSNumber numberWithDouble:_longitude]?: [NSNumber numberWithDouble:tempLongitude]
              forKey:  @"longitude" ];
    if (cityModel.cityId.length==0) {
        [param setObject:[NSNumber numberWithInt:1]
                  forKey: @"needLocation" ];
    }
    else
    {
        [param setObject:[NSNumber numberWithInt:0]
                  forKey: @"needLocation" ];
    }
    
    [param setObject: @"0"
              forKey: @"provinceId" ];
    [param setObject: cityid ? cityid:@"0"
              forKey: @"cityId "];
    [param setObject: @"0"
              forKey: @"countyId" ];
    [param setObject: [NSNumber numberWithInt:30]
              forKey: @"pageSize" ];
    [param setObject: [NSNumber numberWithInteger:self.pageNum]?:[NSNumber numberWithInt:1]
              forKey: @"page" ];
    [param setObject:  @""
              forKey: @"serchContent"];
    [param setObject:self.selectType?:@""
              forKey:  @"type"];//cell的筛选
    [param setObject:  @"0"
              forKey:  @"merchantType"];//商家类型
    
    self.parameters = param;
    
    [NetManager afPostRequest:api parms:param finished:^(id responseObj) {

        self.mainTableView.mj_footer.hidden = NO;
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            self.resultNum = responseObj[@"data"][@"resultNum"];
            self.isInnerNetState = [responseObj[@"data"][@"inOrOutStatus"] integerValue];

            NSMutableArray *systemArray = [NSMutableArray new];
            systemArray = responseObj[@"data"][@"systemNews"];
            [self setsystemlabarr:systemArray];
            
            if (_firstStatus == NO && self.pageNum == 1) {
                _firstStatus = YES;
                [[NSUserDefaults standardUserDefaults] setObject:cityModel.name forKey:@"HistoryCity"];
                   [[NSUserDefaults standardUserDefaults] setObject:cityModel.cityId forKey:@"HistoryCityId"];
                cityModel = [ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"city"]];
                countyModel =[ZCHCityModel yy_modelWithJSON:responseObj[@"data"][@"city"]];;
                [self.locationBtn setTitle:cityModel.name forState:UIControlStateNormal];

            }
            if (self.pageNum == 1) {

                [_dataArray removeAllObjects];
                [_scrollImageArray removeAllObjects];
                [_scrollImageHrefArray removeAllObjects];
            }

            if (responseObj[@"data"][@"commodityList"]) {

                if (self.pageNum == 1) {
                    _dataArray = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"commodityList"]]];
                    NSArray *adArr = responseObj[@"data"][@"carouselImg"];
                    if (adArr.count > 0) {
                        for (NSDictionary *dic in adArr) {
                            [_scrollImageArray addObject:dic[@"picUrl"]];
                            [_scrollImageHrefArray addObject:dic[@"picHref"]];
                        }
                        _adScrollView.imageURLStringsGroup = _scrollImageArray;
                    } else {
                        self.defaultTopView.image = [UIImage imageNamed:@"carousel"];
                    }

                    //判断UIStyle类型
                    if ([responseObj[@"data"][@"commodityList"] count] > 0 && [responseObj[@"data"][@"carouselImg"] count] > 0) {
                        _style = UIStyleBoth;
                    }else if ([responseObj[@"data"][@"commodityList"] count] == 0 && [responseObj[@"data"][@"carouselImg"] count] > 0) {
                        _style = UIStyleOnlyScroll;
                    }else if ([responseObj[@"data"][@"commodityList"] count] > 0 && [responseObj[@"data"][@"carouselImg"] count] == 0) {
                        _style = UIStyleOnlyList;
                    }else if ([responseObj[@"data"][@"commodityList"] count] == 0 && [responseObj[@"data"][@"carouselImg"] count] == 0) {
                        _style = UIStyleNone;
                    }
                } else {//和判断 pageNum页数对应

                    [_dataArray addObjectsFromArray:[NSArray yy_modelArrayWithClass:[HomeDefaultModel class] json:responseObj[@"data"][@"commodityList"]]];

                }
               
                if ([responseObj[@"data"][@"commodityList"] count] < 30) {
                    self.mainTableView.mj_footer.state = MJRefreshStateNoMoreData;
                    [self.mainTableView.mj_header endRefreshing];
                    [self.mainTableView.mj_footer endRefreshing];
                    [_mainTableView reloadData];
                    return;
                }
            }
        } else {//和[responseObj[@"code"]对应
            [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];
        }
        [self.mainTableView.mj_footer endRefreshing];
        [self.mainTableView.mj_header endRefreshing];
        [_mainTableView reloadData];

    } failed:^(NSString *errorMsg) {//和请求数据NetManager afPostRequest:对应
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:1.5];;
    }];
}

#pragma mark - 懒加载
- (UIView *)moreView {

    if (!_moreView) {
        _moreView = [[UIView alloc] init];
        _moreView.backgroundColor = White_Color;
        [self.view addSubview:_moreView];
        _moreView.frame = CGRectMake(0, 0, (kSCREEN_WIDTH - 40)/3, 30*9);
        _moreView.hidden = YES;
        _moreView.layer.borderWidth = 1;
        _moreView.layer.borderColor = kColorRGB(0xdedede).CGColor;
        NSArray *titleArr = @[@"广告牌匾",@"家政保洁",@"搬       家",@"空气治理",@"瓷砖美缝",@"软包纱窗",@"智能家居",@"房产中介",@"其       他"];
        for (NSInteger i = 0; i < 9; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 30*i, (kSCREEN_WIDTH - 40)/3, 30);
            [btn setTitleColor:kColorRGB(0x404040) forState:UIControlStateNormal];
            btn.tag = i;
            if (IPhone4) {
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
            } else if (IPhone5) {
                btn.titleLabel.font = [UIFont systemFontOfSize:13];
            } else {
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
            }
            [btn addTarget:self action:@selector(pushShopListVc:) forControlEvents:UIControlEventTouchUpInside];
            [_moreView addSubview:btn];
        }

    }
    return _moreView;
}

#pragma mark - 店铺分类的跳转事件
- (void)didClickTypeBtn:(UITapGestureRecognizer *)sender {
    UIView *view = sender.view;
    NSLog(@"%ld",(long)view.tag);
    HomeClassificationDetailViewController *controller = [HomeClassificationDetailViewController new];
    controller.index = view.tag;
    controller.latitude = _latitude;
    controller.longitude = _longitude;
    controller.cityModel = cityModel;
    controller.origin = @"0";
    [self.navigationController pushViewController:controller animated:true];
}

- (void)getBroadcastData {
    [self NetworkOfNewBroadcastWithSuccess:^{
        [self.viewBroadcast setDataWith:self.modelHomeBroadcast];
    }];
}

- (void)NetworkOfNewBroadcastWithSuccess:(void(^)(void))successed {
    NSString *URL = @"citywiderecomend/v2/getTodayCounts.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"flag"] = @(1);
    parameters[@"countyId"] = countyModel ? countyModel.cityId : @"0";
    parameters[@"cityId"] = cityModel ? cityModel.cityId : @"0";
    [NetWorkRequest getJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        if ([result[@"code"] integerValue] == 1000) {
            NSInteger oldCounts = self.modelHomeBroadcast.todayCounts.integerValue;
            self.modelHomeBroadcast = [NetworkOfHomeBroadcast yy_modelWithJSON:result[@"data"]];
            NSInteger newCounts = self.modelHomeBroadcast.todayCounts.integerValue;
            NSInteger iCount = newCounts - oldCounts;
            BOOL isPlay = [[NSUserDefaults standardUserDefaults] boolForKey:@"HomeBroadcastPlaySound"];
            if (isPlay) {
                if (iCount > 3) {
                    [self.player playWithCount:2];
                }else if (iCount > 0){
                    [self.player playWithCount:iCount - 1];
                }
            }
            if (successed) {
                successed();
            }
        }
    } fail:^(id error) {}];
}

-(BOOL)isAvaliableToMJRefresh{
    return (self.isViewLoaded &&self.view.window);
}
#pragma mark dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.bottomShareView removeFromSuperview];
    self.bottomShareView = nil;
}

//一个系统消息的协议，没啥用，不写会有警告
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index
{
    
}

@end
