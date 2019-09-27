//
//  VIPExperienceShowViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/27.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "VIPExperienceShowViewController.h"
#import "VIPExperienceModel.h"
#import "VIPExperienceTableViewCell.h"
#import "SDCycleScrollView.h"
#import "VIPExperienceViewController.h"
#import "AdvertisementWebViewController.h"
#import "ZCHPublicWebViewController.h"
#import "WorkTypeModel.h"
#import "DecorateInfoNeedView.h"
#import "DecorateCompletionViewController.h"
#import "VipGroupViewController.h"
#import "BLEJCalculatorGetTempletByCompanyId.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "BLEJCalculatorBaseAndSuppleListModel.h"
#import "ZCHBudgetGuideConstructionCaseModel.h"
#import "BLEJBudgetGuideController.h"
#import "ZYCShareView.h"
#import "VIPExperienceView0.h"
#import "VIPExperienceView1.h"
#import "VIPExperienceView2.h"
#import "CompanyCertificationController.h"
#import "ZCHCalculatorItemsModel.h"
#import "BLRJCalculatortempletModelAllCalculatorcompanyData.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
#import "AppDelegate.h"
#import "SNTabBarController.h"
#import "JinQiViewController.h"
#import "SendFlowersViewController.h"
#import "XianHuaJinQiGuanzhuCell.h"
@interface VIPExperienceShowViewController ()<UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 shareView
 */
@property (strong, nonatomic) ZYCShareView *shareView;
//@property (strong, nonatomic) VIPExperienceModel *model;
@property (strong, nonatomic) SDCycleScrollView *topCycleScrollView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIImageView *imageViewLogo;
@property (strong, nonatomic) UILabel *labelTitle;
@property (strong, nonatomic) UILabel *labelID;
@property (strong, nonatomic) UIButton *buttonVIP;
@property (strong, nonatomic) UIButton *buttonCertification;
@property (strong, nonatomic) WorkTypeModel *typeModel;
@property (strong, nonatomic) DecorateInfoNeedView *infoView;
@property (assign, nonatomic) NSInteger code;// 记录是否可以点击跳转计算器界面(是否设置过基础模板)
// 新添加的模板
@property (strong, nonatomic) NSMutableArray *suppleListArr;
// 基础模板
@property (strong, nonatomic) NSMutableArray *baseItemsArr;
// 置顶的公司列表
@property (strong, nonatomic) NSMutableArray *topConstructionList;
// 基础模板中的其他信息
@property (strong, nonatomic) BLRJCalculatortempletModelAllCalculatorTypes *calculatorTempletModel;
// 预算报价的顶部图片
@property (strong, nonatomic) NSMutableArray *topCalculatorImageArr;
// 预算报价的底部图片
@property (strong, nonatomic) NSMutableArray *bottomCalculatorImageArr;
// 施工案例
@property (strong, nonatomic) NSMutableArray *constructionCase;

@property (nonatomic,strong) VIPExperienceView0 *popView;

@property (nonatomic,strong) VIPExperienceView1 *popView1;

@property (nonatomic,strong) VIPExperienceView2 *popView2;

@property (strong, nonatomic) NSMutableDictionary *companyDic;

@property (nonatomic,strong) UIImageView  *xianHua;
@property (nonatomic,strong) UIImageView  *jinQi;
@property (nonatomic,strong) UILabel  *xianHuaL;
@property (nonatomic,strong) UILabel  *jinQiL;
@property (nonatomic,strong) UIView    *FlipView;
@property (nonatomic,strong) UIView    *BaseView;

@end

@implementation VIPExperienceShowViewController
#pragma mark lazy
- (UIView *)headerView {
    if (!_headerView) {
//headerView
        _headerView = [UIView new];
        _headerView.frame = CGRectMake(0, 0, 0, 150 + kSCREEN_WIDTH * 0.6);
        [_headerView addSubview:self.topCycleScrollView];
//imageViewLogo
        self.imageViewLogo = [[UIImageView alloc] init];
        [_headerView addSubview:self.imageViewLogo];
        self.imageViewLogo.width = 100;
        self.imageViewLogo.height = 100;
        self.imageViewLogo.X = 15;
        self.imageViewLogo.Y = 25;
        self.imageViewLogo.contentMode = 2;
        self.imageViewLogo.clipsToBounds = true;
//labelTitle
        self.labelTitle = [UILabel new];
        [_headerView addSubview:self.labelTitle];
        [self.labelTitle setFont:[UIFont systemFontOfSize:20]];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(25);
            make.left.equalTo(self.imageViewLogo.mas_right).offset(10);
        }];
        [self.labelTitle setTextColor:[UIColor blackColor]];
//buttonVIP
        self.buttonVIP = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_headerView addSubview:self.buttonVIP];
        [self.buttonVIP mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(Width_Layout(100));
            make.height.equalTo(Height_Layout(35));
            make.bottom.equalTo(self.imageViewLogo.mas_bottom);
            make.left.equalTo(self.labelTitle.mas_left);
        }];
        [self.buttonVIP setTitle:@" 会员介绍 " forState:(UIControlStateNormal)];
        [self.buttonVIP.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [self.buttonVIP setTitleColor:[UIColor colorWithRed:1.00 green:0.52 blue:0.00 alpha:1.00] forState:(UIControlStateNormal)];
        self.buttonVIP.layer.cornerRadius = 6.0f;
        self.buttonVIP.layer.masksToBounds = true;
        self.buttonVIP.layer.borderWidth = 1.0f;
        self.buttonVIP.layer.borderColor = [UIColor colorWithRed:1.00 green:0.52 blue:0.00 alpha:1.00].CGColor;
//        [self.buttonVIP addTarget:self action:@selector(didTouchButtonVip) forControlEvents:(UIControlEventTouchUpInside)];
//labelID
        self.labelID = [UILabel new];
        [_headerView addSubview:self.labelID];
        [self.labelID setFont:[UIFont systemFontOfSize:13]];
        self.labelID.text = @"";
        [self.labelID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(Height_Layout(35));
            make.bottom.equalTo(self.imageViewLogo.mas_bottom);
            make.right.equalTo(-10);
        }];
//buttonCertification
        self.buttonCertification = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_headerView addSubview:self.buttonCertification];
//        self.buttonCertification.hidden = false;
        [self.buttonCertification mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(25);
            make.right.equalTo(-10);
            make.left.greaterThanOrEqualTo(self.labelTitle.mas_right).offset(0);
            make.centerY.equalTo(self.labelTitle.mas_centerY);
            make.height.equalTo(20);
        }];
        [self.buttonCertification setTitle:@" 未认证 " forState:(UIControlStateNormal)];
        [self.buttonCertification.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.buttonCertification setTitleColor:[UIColor colorWithRed:1.00 green:0.52 blue:0.00 alpha:1.00] forState:(UIControlStateNormal)];
        self.buttonCertification.layer.cornerRadius = 3.0f;
        self.buttonCertification.layer.masksToBounds = true;
        self.buttonCertification.layer.borderWidth = 1.0f;
        self.buttonCertification.layer.borderColor = [UIColor colorWithRed:1.00 green:0.52 blue:0.00 alpha:1.00].CGColor;
        [self.buttonCertification addTarget:self action:@selector(didTouchButtonCertification) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _headerView;
}

- (SDCycleScrollView *)topCycleScrollView {
    if (!_topCycleScrollView) {
        WeakSelf(self)
        _topCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 150, BLEJWidth, kSCREEN_WIDTH * 0.6) delegate:self placeholderImage:[UIImage imageNamed:@"topbanner_default"]];
        _topCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        _topCycleScrollView.backgroundColor = [UIColor blackColor];
        _topCycleScrollView.autoScrollTimeInterval = BANNERTIME;
        _topCycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            SubsidiaryModel *model = weakself.modelSubsidiary.headImgs[currentIndex];
            NSString *webUrl = model.picHref;
            if (webUrl.length > 0) {
                if (![webUrl ew_isUrlString]) {
                    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"网址格式错误， 无法查看"];
                    return;
                }
                AdvertisementWebViewController *adWebViewVC = [[AdvertisementWebViewController alloc] init];
                adWebViewVC.webUrl = webUrl;
                [weakself.navigationController pushViewController:adWebViewVC animated:YES];
            }
        };
    }
    return _topCycleScrollView;
}

#pragma mark Network
- (void)Network {
    ShowMB
    NSString *URL = @"company/getNoVipYellowPage.do";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"agencyId"] = GETAgencyId;
    parameters[@"companyId"] = self.companyId;
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        HiddenMB
        if ([result[@"code"] integerValue] == 1000) {
            SubsidiaryModel *model = [SubsidiaryModel yy_modelWithJSON:result[@"data"]];
            self.companyDic =result[@"data"][@"company"];
        
            if (!self.modelSubsidiary) {
                self.modelSubsidiary = [SubsidiaryModel yy_modelWithJSON:result[@"data"][@"company"]];
            }
            if (self.modelSubsidiary.authentication == 1) {
                [self.buttonCertification setTitle:@" 已认证 " forState:(UIControlStateNormal)];
            }
            self.modelSubsidiary.headImgs = model.headImgs;
            self.modelSubsidiary.footImgs = model.footImgs;
            [self.modelSubsidiary.footImgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SubsidiaryModel *m = obj;
                UIImageView *imageView = [UIImageView new];
                [imageView sd_setImageWithURL:[NSURL URLWithString:m.picUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    NSLog(@"%f",imageView.image.size.height);
                    m.imageHeight = Height_Layout(imageView.image.size.height);
                }];
            }];
            [self.imageViewLogo sd_setImageWithURL:[NSURL URLWithString:self.modelSubsidiary.companyLogo]];
            self.labelTitle.text = self.modelSubsidiary.companyName;
            self.labelID.text = [NSString stringWithFormat:@"id:%@",self.modelSubsidiary.companyId];
            NSArray *array = [self.modelSubsidiary.headImgs valueForKeyPath:@"picUrl"];
            self.topCycleScrollView.imageURLStringsGroup = array;
            self.modelSubsidiary.detailedAddress = result[@"data"][@"company"][@"companyAddress"];
            NSInteger type = [self.modelSubsidiary.companyType integerValue];
            if (type == 1018 || type == 1064 || type == 1065) {
                self.modelSubsidiary.isCompany = true;
            }
            [self makeShareView];
        }
        [self.tableView reloadData];
    } fail:^(NSError *error) {
        HiddenMB
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"免费版商家企业网";
    self.shareView = [ZYCShareView sharedInstance];
    self.typeModel = [WorkTypeModel new];
    self.typeModel = [[CacheData sharedInstance] objectForKey:KRoleTypeList];
    [self setupRightButton];
    [self addBottomView];
    [self createTableView];
    self.companyDic =[NSMutableDictionary dictionary];
    self.labelID.text = [NSString stringWithFormat:@"id:%@",self.modelSubsidiary.companyId];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:@"Viptongzhi" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddCountForFlower) name: @"kRealeaseToRefreshData" object:nil];
  
    
  
    [self istouchfrom];
}
-(void)AddCountForFlower{

    [self Network];
    [self.tableView reloadData];
    self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
    self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
}
#pragma mark - 弹出试图

-(void)notice:(id)sender{
    NSLog(@"%@",sender);
    [self isshowpopview1];
}

-(void)istouchfrom
{
    if (self.isfromLogup) {
        [self.popView showView];
    }
}

-(void)isshowpopview1
{
    if (self.isfromLogup) {
        [self.popView1 showView];
    }
}

-(VIPExperienceView0 *)popView
{
    if(!_popView)
    {
        _popView = [[VIPExperienceView0 alloc] init];
        [_popView.rightBtn addTarget:self action:@selector(popviewbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _popView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableSingleTap)];
        [_popView addGestureRecognizer:singleTap];
        [_popView.leftBtn addTarget:self action:@selector(popview1leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popView;
}

-(void)popviewbtnclick
{
    [self.popView dismissAlertView];

    CompanyCertificationController *vc = [[UIStoryboard storyboardWithName:@"CompanyCertificationController" bundle:nil] instantiateInitialViewController];
    vc.companyId = self.companyId;
    vc.isfromlogin = self.isfromLogup;
    vc.CertificatSuccessBlock = ^{
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(VIPExperienceView1 *)popView1
{
    if(!_popView1)
    {
        _popView1 = [[VIPExperienceView1 alloc] init];
        _popView1.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableSingleTap1)];
        [_popView1 addGestureRecognizer:singleTap];
        [_popView1.rightBtn addTarget:self action:@selector(popview2rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_popView1.leftBtn addTarget:self action:@selector(newpopview2leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popView1;
}

-(VIPExperienceView2 *)popView2
{
    if(!_popView2)
    {
        _popView2 = [[VIPExperienceView2 alloc] init];
        _popView2.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableSingleTap2)];
        [_popView2 addGestureRecognizer:singleTap];
        [_popView2.rightBtn addTarget:self action:@selector(popview3rightbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_popView2.leftBtn addTarget:self action:@selector(newpopview1leftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popView2;
}

-(void)tableSingleTap
{
    [self.popView dismissAlertView];
}

-(void)tableSingleTap1
{
    [self.popView1 dismissAlertView];
}

-(void)tableSingleTap2
{
    [self.popView2 dismissAlertView];
}

-(void)popview1leftbtnclick
{
    [self.popView dismissAlertView];
    [self.popView2 showView];
    
}

-(void)popview1rightbtnclick
{
    [self.popView dismissAlertView];
    [self.popView2 showView];
}

//查看会员特权
-(void)popview2rightbtnclick
{
    [self.popView1 dismissAlertView];
    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.modelSubsidiary.companyId;
    VC.isFromNotVipYellow = NO;
    __weak typeof(self) weakSelf = self;
    VC.successBlock = ^() {
    };
    [weakSelf.navigationController pushViewController:VC animated:YES];
}

//查看会员特权
-(void)popview3rightbtnclick
{
    [self.popView2 dismissAlertView];
    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.modelSubsidiary.companyId;
    VC.isFromNotVipYellow = NO;
    __weak typeof(self) weakSelf = self;
    VC.successBlock = ^() {
    };
    [weakSelf.navigationController pushViewController:VC animated:YES];
}

-(void)newpopview1leftbtnclick
{
    [self.popView2 dismissAlertView];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SNTabBarController * main = [[SNTabBarController alloc] init];
    appDelegate.window.rootViewController = main;
}

-(void)newpopview2leftbtnclick
{
    [self.popView1 dismissAlertView];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    SNTabBarController * main = [[SNTabBarController alloc] init];
    appDelegate.window.rootViewController = main;
}

#pragma mark - 添加底部视图

- (void)addBottomView {
  
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, BLEJHeight - 50, BLEJWidth, 50)];
        bottomView.backgroundColor = White_Color;
        [self.view addSubview:bottomView];
        
        UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth/4, bottomView.height)];
        [phoneBtn setImage:[UIImage imageNamed:@"bottomPhone"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [phoneBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [phoneBtn setTitle:@"电话咨询" forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(didClickPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:phoneBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(phoneBtn.right, 0, 1, bottomView.height)];
        line.backgroundColor = kBackgroundColor;
        [bottomView addSubview:line];
        
        // 242 105 71
        UIButton *collectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(phoneBtn.width + 1, 0, BLEJWidth/4-1, bottomView.height)];
        [collectionBtn setImage:[UIImage imageNamed:@"noSelectCollection"] forState:UIControlStateNormal];
        [collectionBtn setImage:[UIImage imageNamed:@"selectCollection"] forState:UIControlStateSelected];
        collectionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [collectionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        [collectionBtn setTitle:@"赠送礼物" forState:UIControlStateNormal];
        [collectionBtn setImage: [UIImage imageNamed:@"icon_liwu"] forState:normal];
        [collectionBtn setTitle:@"赠送礼物" forState:UIControlStateSelected];
        [collectionBtn addTarget:self action:@selector(didClickCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    
        [bottomView addSubview:collectionBtn];
        
        UIButton *priceBtn = [[UIButton alloc] initWithFrame:CGRectMake(collectionBtn.right, 0, BLEJWidth/4, bottomView.height)];
        priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        priceBtn.backgroundColor = kCustomColor(242, 105, 71);
        [priceBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [priceBtn setTitle:@"免费报价" forState:UIControlStateNormal];
        [priceBtn addTarget:self action:@selector(didClickPriceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:priceBtn];
        
        UIButton *houseBtn = [[UIButton alloc] initWithFrame:CGRectMake(priceBtn.right, 0, BLEJWidth/4, bottomView.height)];
        houseBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        houseBtn.backgroundColor = kMainThemeColor;
        [houseBtn setTitleColor:White_Color forState:UIControlStateNormal];
        [houseBtn setTitle:@"在线预约" forState:UIControlStateNormal];
        [houseBtn addTarget:self action:@selector(didClickHouseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:houseBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self Network];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"threemorewithe"]];
    [rightButton addSubview:imageView];
    imageView.height = 30;
    imageView.width = 30;
    imageView.center = rightButton.center;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.modelSubsidiary.footImgs.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.modelSubsidiary.arrayBasicTitleInShow.count + 1 + 1;
    }else{
        SubsidiaryModel *model = self.modelSubsidiary.footImgs[section - 1];
        NSInteger number = 0;
        if (model.picUrl.length) {
            number++;
            if (model.picTitle.length) {
                number ++;
            }
        }
        return number;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        SubsidiaryModel *model = self.modelSubsidiary.footImgs[indexPath.section - 1];
        NSInteger row = 0;
        row = model.picTitle.length?1:0;
        if (indexPath.row == row) {
            return model.imageHeight;
        }
    }
        return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VIPExperienceTableViewCell *cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:2];
            cell.labelTitle.text = @"服务范围";
            cell.textView.userInteractionEnabled = false;
            cell.textView.text = self.modelSubsidiary.serviceScope;
            [cell.textView setBackgroundColor:[UIColor clearColor]];
            return cell;
        }else if (indexPath.row == self.modelSubsidiary.arrayBasicTitleInShow.count + 1) {
            VIPExperienceTableViewCell *cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:3];
            cell.textView.userInteractionEnabled = false;
            cell.textView.text = self.modelSubsidiary.companyIntroduction;
            [cell.textView setBackgroundColor:[UIColor clearColor]];
            return cell;
        }else{
            VIPExperienceTableViewCell *cell = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:1];
            [cell setModelInShow:self.modelSubsidiary andIndexPath:indexPath];
            return cell;
        }
    }else{
        SubsidiaryModel *model = self.modelSubsidiary.footImgs[indexPath.section - 1];
        NSInteger row = 0;
        if (model.picTitle.length) {
            row = 1;
        }
        if (indexPath.row == row) {
            VIPExperienceTableViewCell *cell2 = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:4];
            [cell2.imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"topbanner_default"]];
            cell2.imageView.contentMode = 2;
            [cell2 setBackgroundColor:[UIColor blackColor]];
            return cell2;
        }else{
            VIPExperienceTableViewCell *cell3 = [VIPExperienceTableViewCell cellWithTableView:tableView AndIndex:5];
            cell3.labelTitle.text = model.picTitle;
            return cell3;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 80;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    

    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section ==0) {
        
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"XianHuaJinQiGuanzhuCell" owner:nil options:nil];
        XianHuaJinQiGuanzhuCell *CEll = [nibArray lastObject];
       [CEll setData:self.companyDic];
      
        return CEll;
    }
    return [UIView new];

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}




- (void)didTouchRightButton {
    //编辑
    [self showMore];
}

- (void)pushToEdit {
    VIPExperienceViewController *controller = [VIPExperienceViewController new];
    self.modelSubsidiary.headImgs = [self.modelSubsidiary.headImgs mutableCopy];
    self.modelSubsidiary.footImgs = [self.modelSubsidiary.footImgs mutableCopy];
    controller.model = self.modelSubsidiary;
    controller.companyId = self.companyId;
    controller.companyName = self.companyName;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)showMore {
    // 弹出的自定义视图
    NSArray *array;
    //是否有编辑权限
    if ([self.modelSubsidiary.agencysJob integerValue] == 1002 || self.modelSubsidiary.implement) {
        array = @[@"分享", @"编辑"];
    }else
        array = @[@"分享"];
    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(self.view.bounds.size.width-100, 64, 120, 0) selectData:array images:nil action:^(NSInteger index) {
        switch (index) {
            case 0://分享
                [self share];
                break;
            case 1://编辑
                [self pushToEdit];
                break;
            default:
                break;
        }
    } animated:YES];
}

- (void)share {
    [self.shareView share];
}

- (void)didTouchButtonVip {
    VipGroupViewController *VC = [[UIStoryboard storyboardWithName:@"VipGroupViewController" bundle:nil] instantiateInitialViewController];
    VC.companyId = self.modelSubsidiary.companyId;
    VC.isFromNotVipYellow = YES;
    __weak typeof(self) weakSelf = self;
    VC.successBlock = ^() {
    };
    [weakSelf.navigationController pushViewController:VC animated:YES];
}

- (void)didClickPhoneBtn:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.modelSubsidiary.companyPhone]]];
}

- (void)didClickHouseBtn:(UIButton *)sender {
    self.infoView = [[NSBundle mainBundle] loadNibNamed:@"DecorateInfoNeedView" owner:nil options:nil].lastObject;
    self.infoView.frame = self.view.frame;
    [self.infoView.finishButton addTarget:self action:@selector(finishiAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.infoView];
    // 店铺和公司的界面区别
    [self.infoView.areaTF removeFromSuperview];
    [self.infoView.timeTF removeFromSuperview];
    self.infoView.tipLabel.text = @"本公司业务人员会与您电话沟通，请确保电话畅通！     ";
    //    self.infoView.tipLabelHeight.constant = 30;
    self.infoView.protocolImageTopToPhoneTFCon.constant = 6;
    MJWeakSelf;
    self.infoView.sendVertifyCodeBlock = ^{
        [weakSelf sendvertifyAction];
    };
    self.infoView.hidden = NO;
    // 在线预约 后台数据统计
    [NSObject needDecorationStatisticsWithConpanyId:self.modelSubsidiary.companyId];
}

#pragma  mark 发送验证码
- (void)sendvertifyAction {
    [self.infoView endEditing:YES];
    if (![self.infoView.phoneTF.text ew_justCheckPhone]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的手机号"];
        return;
    }
    NSString* url = [NSString stringWithFormat:@"%@%@", BASEURL, @"callDecoration/sendPhoneCode.do"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.infoView.phoneTF.text forKey:@"phone"];
    [param setObject:self.modelSubsidiary.companyId forKey:@"companyId"];
    MJWeakSelf;
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
        switch (code) {
            case 1000:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码发送成功"];
                [NSObject timelessWithSecond:120 button:weakSelf.infoView.sendVertifyBtn];
                break;
            case 1001:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"当月已经预约过该公司"];
                break;
            default:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"操作失败或操作过于频繁"];
                break;
        }
    } failed:^(NSString *errorMsg) {

    }];
}

#pragma mark  完成
- (void)finishiAction {
    if ([self.infoView.nameTF.text isEqualToString:@""]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入您的姓名"];
        return;
    }
    if (![self.infoView.phoneTF.text ew_checkPhoneNumber]) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入正确的联系方式"];
        return;
    }
    //    if (!self.infoView.textFieldImageVerificationCode.text.length) {
    //        SHOWMESSAGE(@"请输入图形验证码")
    //        return;
    //    }
    if (self.infoView.vertifyCodeTF.text.length != 6) {
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入6位数的验证码"];
        return;
    }
    NSInteger proType = -1;
    if ([self.infoView.itemTF.text isEqualToString:@"量房"]) {
        proType = 0;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"设计"]) {
        proType = 1;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"施工"]) {
        proType = 2;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"维修"]) {
        proType = 3;
    }
    if ([self.infoView.itemTF.text isEqualToString:@"其他"]) {
        proType = 4;
    }
    self.infoView.hidden = YES;
#warning 图形验证码 后台拖后腿 后续版本增加该功能 暂时注释
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.infoView.vertifyCodeTF.text?:@"" forKey:@"phoneCode"];
    [dic setObject:self.infoView.phoneTF.text?:@"" forKey:@"phone"];
    [dic setObject:self.infoView.nameTF.text?:@"" forKey:@"fullName"];
    [dic setObject:self.modelSubsidiary.companyId?:@"" forKey:@"companyId"];
    [dic setObject:self.modelSubsidiary.companyType?:@"" forKey:@"companyType"];
    [dic setObject:@(proType) forKey:@"proType"];
    [dic setObject:@"0" forKey:@"agencyId"];
    [dic setObject:@"0" forKey:@"callPage"];
    [self upDataRequest:dic];
}

- (void)upDataRequest:(NSMutableDictionary *)dic {
    [[UIApplication sharedApplication].keyWindow hudShow];
    __weak typeof(self)  weakSelf = self;
     [dic setObject:self.origin?:@"0" forKey:@"origin"];
    NSString *url = [BASEURL stringByAppendingString:@"callDecoration/v2/save.do"];
    [NetManager  afGetRequest:url parms:dic finished:^(id responseObj) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        switch ([responseObj[@"code"] integerValue]) {
                //喊装修成功
            case 1000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您已提交成功请等待回复"];
                // 睡一秒
                [NSThread sleepForTimeInterval:1];
//                DecorateCompletionViewController *completionVC = [[DecorateCompletionViewController alloc] init];
//                completionVC.dataDic = responseObj[@"data"];
//                completionVC.companyType = weakSelf.modelSubsidiary.companyType;
////                NSString *constructionType = weakSelf.modelSubsidiary.type;
//                completionVC.constructionType = constructionType;
//                [self.navigationController pushViewController:completionVC animated:YES];
                break;
            }
            case 1001:
                break;
                //            本月已喊过装修
            case 1002:
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"您本月已经预约过了"];
                break;
                //            不在装修区域
            case 1003:
                self.infoView.hidden = YES;
                [self replySubmit:dic];
                break;
                //             该区域暂无接单公司
            case 1004:
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"该区域暂无接单公司"];
                break;
            case 2000:
            {
                self.infoView.hidden = YES;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"预约失败，稍后重试"];
                break;
            }
            case 2001:
            {
                self.infoView.hidden = NO;
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码错误"];
                break;
            }
            default:
                break;
        }

    } failed:^(NSString *errorMsg) {

        [weakSelf.view hiddleHud];
        self.infoView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}

#pragma mark   不在装修区域  是否继续提交
- (void)replySubmit:(NSMutableDictionary *)dic {
    //该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:@"提示" message:@"该地区不在装修公司服务区域，继续提交，我们会为您提供本地区优秀公司服务，是否继续提交？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    __weak typeof(self)  weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"提交" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [dic setObject:@(1) forKey:@"type"];
        [weakSelf upDataRequest:dic];
    }];
    [aler addAction:action];
    [aler addAction:action1];
    [self presentViewController:aler animated:YES completion:nil];
}

- (void)didTouchButtonCertification {

}

#pragma mark - 获取计算器模板相关的内容
- (void)getData {
 
    NSString *urlStr =[BASEURL stringByAppendingString:BLEJCalculatorGetTempletByCompanyIdUrl];
    NSString *agencyid=   [[NSUserDefaults standardUserDefaults ]objectForKey:@"alias"];
    
    //NSString *companyId = self.companyID;
    NSString *companyId = @"1398";
    NSDictionary *parameter = @{@"companyId":companyId};
    
    [NetManager afPostRequest:urlStr parms:parameter finished:^(id responseObj) {
        //        [self getDataWithType:@"1"];
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            
            
            [self.baseItemsArr removeAllObjects];
            [self.suppleListArr removeAllObjects];
            
            
            
            NSDictionary *dictData= [responseObj objectForKey:@"data"];
            NSMutableArray *companyItemArray =[NSMutableArray array];
            companyItemArray=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[BLRJCalculatortempletModelAllCalculatorTypes class] json:dictData[@"list"]]];
            for (BLRJCalculatortempletModelAllCalculatorTypes *dict in  companyItemArray) {
                
                if ( dict.templeteTypeNo  > 2000 &&dict.templeteTypeNo <3000) {
                    [self.baseItemsArr addObject:dict];
                }
                if (dict.templeteTypeNo  ==0) {
                    [self.suppleListArr addObject:dict];
                }
            }
            BLRJCalculatortempletModelAllCalculatorcompanyData* companyData=     [BLRJCalculatortempletModelAllCalculatorcompanyData yy_modelWithJSON:dictData[@"company"]];
            
            //   self.allCalculatorCompanyData=companyData;
            
            
            
            
            //如果baseitems数据为空，去本地取出数据
            NSString *strPath = [[NSBundle mainBundle] pathForResource:@"DefaultBaseItem" ofType:@"geojson"];
            NSData *JSONData = [NSData dataWithContentsOfFile:strPath];
            
            id jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *dicTemplet = [[jsonObject
                                                objectForKey:@"data"]objectForKey:@"templet"] ;
            if (self.suppleListArr.count ==0) {
                NSMutableArray *supplyArray = [NSMutableArray arrayWithArray:[[jsonObject
                                                                               objectForKey:@"data"] objectForKey:@"defaultSupplementItemsList"]];
                
                self.suppleListArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:supplyArray]];
            }
            if (self.baseItemsArr.count ==0){
                NSMutableArray *baseItemArray = [NSMutableArray arrayWithArray:[[jsonObject objectForKey:@"data"] objectForKey:@"defaultBaseItemsList"]];
                
                self.baseItemsArr=[NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ZCHCalculatorItemsModel class] json:baseItemArray]];
                
            }
            
            
            
            
            //                if (self.allCalculatorCompanyData.calVip == nil || [self.allCalculatorCompanyData.calVip isEqualToString:@""]) {// 0表示不是会员  还没有开通200
            //                }
            
        }else{
            [[PublicTool defaultTool] publicToolsHUDStr:responseObj[@"msg"] controller:self sleep:1.5];
        }
        
        BLEJBudgetGuideController *VC = [[BLEJBudgetGuideController alloc] init];
        VC.baseItemsArr = self.baseItemsArr;
        VC.origin = @"1";
        VC.suppleListArr = self.suppleListArr;
        VC.calculatorModel= self.calculatorTempletModel;
        VC.constructionCase = self.constructionCase;
        VC.topImageArr = self.topCalculatorImageArr;
        VC.bottomImageArr = self.bottomCalculatorImageArr;
        VC.companyID = [NSString stringWithFormat:@"%@",self.companyId];
        VC.isConVip = @"1";
        //  VC.dispalyNum = self.calculatorTempletModel.displayNumbers;
        [self.navigationController pushViewController:VC animated:YES];
        
    } failed:^(NSString *errorMsg) {
        [[PublicTool defaultTool] publicToolsHUDStr:errorMsg controller:self sleep:1.5];
    }];
}

- (void)didClickPriceBtn:(UIButton *)button {
    [self getData];
}

- (void)makeShareView {
    WeakSelf(self);
    self.shareView.URL = [BASEHTML stringByAppendingString:[NSString stringWithFormat:@"api/company/%@.htm", self.modelSubsidiary.companyId]];;
    self.shareView.imageURL = self.modelSubsidiary.companyLogo;
    self.shareView.companyName = self.modelSubsidiary.companyName;
    self.shareView.shareTitle = self.modelSubsidiary.companyName;
    self.shareView.shareCompanyIntroduction = self.modelSubsidiary.companyIntroduction;
    self.shareView.shareCompanyLogo = self.modelSubsidiary.companyLogo;
    self.shareView.shareViewType = ZYCShareViewTypeCompanyOnly;
    self.shareView.blockQRCode1st = ^{
        FlowersStoryQRCodeViewController *controller = [FlowersStoryQRCodeViewController new];
        [controller.view setBackgroundColor:[UIColor whiteColor]];
        controller.labelTitle.text = @"";
        controller.title = @"二维码分享";
        controller.viewCenter.hidden = true;
        controller.imageView2.hidden = true;
        controller.labelTitle2.hidden = true;
        controller.imageViewTop.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:weakself.shareView.URL imageViewWidth:500];
        controller.imageViewQRCode.hidden = true;
        [weakself.navigationController pushViewController:controller animated:true];
    };
}



- (void)didClickCollectionBtn:(UIButton *)btn {// 收藏(取消)
    

    self.FlipView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight+ 180)];
    [self.view addSubview:self.FlipView];
    
    self.BaseView =[[UIView alloc]initWithFrame:CGRectMake(0, BLEJHeight, BLEJWidth,  180)];
    self.BaseView.backgroundColor =[UIColor whiteColor];
    [self.FlipView addSubview:self.BaseView];
    
    UIButton *BtnGift = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, BLEJWidth/6, 30)];
    
    BtnGift.titleLabel.adjustsFontSizeToFitWidth=YES;
    [BtnGift setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [BtnGift setTitle:@"礼物" forState:UIControlStateNormal];
    
    [self.BaseView addSubview:BtnGift];
    UIButton *btnLine=[[UIButton alloc]initWithFrame:CGRectMake(20,BtnGift.bottom+3 , BLEJWidth/6-10, 1)];
    btnLine.backgroundColor=[UIColor redColor];
    [self.BaseView addSubview:btnLine];
    
    
    _xianHua=[[UIImageView alloc]initWithFrame:CGRectMake(20,80, 40, 40)];
    _xianHuaL=[[UILabel alloc]initWithFrame:CGRectMake(20+_xianHua.right+5, 80+10, 40, 20)];
    _jinQi=[[UIImageView alloc]initWithFrame:CGRectMake(_xianHuaL.right+5,80 , 40, 40)];
    _jinQiL=[[UILabel alloc]initWithFrame:CGRectMake(_jinQi.right+5, 80+10, 40, 20)];
    [_jinQi setContentMode:UIViewContentModeScaleAspectFill];
    [_xianHua setContentMode:UIViewContentModeScaleAspectFill];
    _jinQi.image=[UIImage imageNamed:@"Personcard_Flag"];
    _xianHua.image= [UIImage imageNamed:@"Personcard_Flower"] ;
   
    self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
    self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
    
    _jinQi.userInteractionEnabled=YES;
    _xianHua.userInteractionEnabled =YES;
    UITapGestureRecognizer *Tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToJinQiPurchase)];
    
    UITapGestureRecognizer *Tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(ToXianHuaPurchase)];
    [_jinQi addGestureRecognizer:Tap1];
    [_xianHua addGestureRecognizer:Tap2];
    //     [jinQi addTarget:self action:@selector(ToJinQiPurchase) forControlEvents:UIControlEventTouchUpInside];
    //     [xianHua addTarget:self action:@selector(ToXianHuaPurchase) forControlEvents:UIControlEventTouchUpInside];
    [self.BaseView addSubview:_jinQi];
    [self.BaseView addSubview:_xianHua];
    [self.BaseView addSubview:_jinQiL];
    [self.BaseView addSubview:_xianHuaL];
    
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(hiddenView:)];
    
    [self.FlipView addGestureRecognizer:Tap];
    
    
    
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.FlipView.mj_y = -180;
        self.FlipView.backgroundColor=    [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
    }];
}



- (void)hiddenView:(UITapGestureRecognizer*)tapGesture{
    
    CGPoint selectPoint = [tapGesture locationInView:self.FlipView];
    
    NSLog(@"%@",[NSValue valueWithCGPoint:selectPoint]);
    
    //CGRectContainsPoint(CGRect rect, <#CGPoint point#>)判断某个点是否包含在某个CGRect区域内
    
    if(!CGRectContainsPoint(self.BaseView.frame, selectPoint)){
        
        [UIView animateWithDuration:0.3f animations:^{
            
            // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
            self.FlipView.mj_y += 180 ;
        } completion:^(BOOL finished) {
            [self.FlipView removeFromSuperview];
        }];
        
    }
    
    
    
}
#pragma mark 锦旗的购买事件
-(void)ToJinQiPurchase{
    
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    JinQiViewController *view =[[JinQiViewController alloc]init];
    view.isSendFromCompany =YES;
    view.companyId = self.companyId;
    WeakSelf(self)
   
    [self.navigationController pushViewController:view animated:YES];
    
}
#pragma mark 鲜花的购买事件

-(void)ToXianHuaPurchase{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        // self.FlipView.backgroundColor= [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5 ];
        self.FlipView.mj_y += 180 ;
    } completion:^(BOOL finished) {
        [self.FlipView removeFromSuperview];
    }];
    NSLog(@"++++++++++++++++++");
    SendFlowersViewController *Flowerview =[[SendFlowersViewController alloc]init];
    Flowerview.compamyIDD =self.companyId;
    Flowerview.isCompamyID =YES;
    WeakSelf(self)
    Flowerview.blockIsPay = ^(BOOL isPay) {
        StrongSelf(weakself)
        if (isPay ==YES) {
            [strongself Network];
            [self.tableView reloadData];
            
            self.
            //鲜花的数量加一
//            NSUserDefaults *defaultUser= [NSUserDefaults standardUserDefaults];
//            NSInteger totalDisk = [defaultUser integerForKey:@"XinahuaCount" ];
//
//            totalDisk=totalDisk +1;
//            [defaultUser setInteger:totalDisk  forKey:@"XinahuaCount"];
//            [defaultUser synchronize];
//            strongself.xianHuaL.text = [NSString stringWithFormat:@"%ld",(long)totalDisk];
            self.xianHuaL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"flowerNumber"]];
            self.jinQiL.text =[NSString stringWithFormat:@"%@",self.companyDic[@"pennantNumber"]];
        }
        
    };
    [self.navigationController pushViewController:Flowerview animated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Viptongzhi" object:nil];
    
}

@end
