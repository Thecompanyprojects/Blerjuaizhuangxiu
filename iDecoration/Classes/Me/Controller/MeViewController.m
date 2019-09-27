//
//  MeViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "MeViewController.h"
#import "UserLogoTableViewCell.h"
#import "PersonalInfoViewController.h"
#import "MessageCenterViewController.h"
#import "feedbackVC.h"
#import "ShareView.h"
#import "SpecificationViewController.h"
#import "SettingViewController.h"
#import "MyConstructionSiteViewController.h"
#import "LoginViewController.h"
#import "MyCompanyViewController.h"
#import "MyShopViewController.h"
#import "EditShopViewController.h"
#import "GetUserInfoApi.h"
#import "CreateCompanyViewController.h"
#import "SearchCompanyController.h"
#import "JoinCompanyController.h"
#import <JPUSHService.h>
#import "CollectionViewController.h"
#import "CreatShopUnionController.h"

#import "ShopUnionListController.h"
#import "SearchUnionController.h"

#import "UnionCompanyModel.h"
#import "ShopUnionListModel.h"
#import "SSPopup.h"
#import "ZCHCalculatorPayController.h"
#import "MyBeautifulArtController.h"
#import "ZCHMyPersonCardController.h"

#import "STYMyCashCouponController.h"

#import "NewMyPersonCardController.h"


@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SSPopupDelegate>{
    
    BOOL _isLogined;
    BOOL _isZongjingli;//是否是总经理
    
    BOOL implement;//是否是执行经理
}

@property (nonatomic, strong) UITableView *UserTableView;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) UserInfoModel *userModel;
// 二维码
@property (strong, nonatomic) UIView *TwoDimensionCodeView;

// 消息总数
@property (nonatomic, assign) NSInteger messageNum;
// 使用说明红点
//@property (nonatomic, strong) UILabel *useExplainflagLabel;
@property (nonatomic, strong) UIImageView *useExplainFlagView;

@property (nonatomic, strong) NSMutableArray *companyArray;
@property (nonatomic, strong) NSMutableArray *unionArray;
@property (nonatomic, strong) NSMutableDictionary *vipDic;

@property (nonatomic, strong) UILabel *messageFlagLabel;
@end

@implementation MeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self createUI];
    [self createTableView];
    self.companyArray = [NSMutableArray array];
    self.unionArray = [NSMutableArray array];
    self.vipDic = [NSMutableDictionary dictionary];
    
    self.view.backgroundColor = kBackgroundColor;
    // 退出登录清空消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageNum) name:klognOutNotification object:nil];
    // tabbar角标变化 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageNumData) name:@"kTabBarItemBadageValueChange" object:nil];
    //申请公司成功之后给提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applictionTip) name:@"applicationSuccessNo" object:nil];
    // 退出公司后清空消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessageNum) name:kOutCompany object:nil];
    // 收到聊天消息 跟新消息数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageNumDataWithNetWork) name:kHXUpdateMessageNumberWhenRevievedMessage object:nil];
  
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self requestVip];
    
    _isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    
    if (_isLogined == YES) {
        //        获取用户模型
        self.userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        //        添加二维码视图
        [self addTwoDimensionCodeView];
        
        [self.UserTableView reloadData];
    }
    [self getMessageNumDataWithNetWork];
    // 使用说明红点提示是否显示
    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
    if (kHasUseExpalinUpdate && !isReade) {
        self.useExplainFlagView.hidden = NO;
    } else {
        self.useExplainFlagView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI {
    
    self.title = @"个人中心";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:@"refreshUserState" object:nil];
}

#pragma 添加二维码视图
- (void)addTwoDimensionCodeView {
    
    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight)];
//    self.TwoDimensionCodeView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.TwoDimensionCodeView.backgroundColor = White_Color;
    [self.view addSubview:self.TwoDimensionCodeView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickShadowView:)];
    [self.TwoDimensionCodeView addGestureRecognizer:tap];
    
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.3, BLEJHeight * 0.5, BLEJWidth * 0.4, BLEJWidth * 0.4)];
    //    codeView.size = CGSizeMake(BLEJWidth * 0.4, BLEJWidth * 0.4);
    //    codeView.center = self.TwoDimensionCodeView.center;
    //    codeView.backgroundColor = kRandomColor;
    [self.TwoDimensionCodeView addSubview:codeView];
    
    // [BASEHTML stringByAppendingString:@"resources/html/fenxiang.jsp?a=a"]
        NSString *shareURL = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.blej.chaojiguanliyuan";
//    NSString *shareURL = [NSString stringWithFormat:@"http://testapi.bilinerju.com/resources/html/shigongrizhi1.jsp?constructionId=%ld", (long)self.consID];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.companyLogo]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            codeView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:shareURL logoImageName:nil logoScaleToSuperView:0.1];
        });
    });
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.top - 80, BLEJWidth, 50)];
    centerLabel.text = @"邀请您体验";
    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.font = [UIFont boldSystemFontOfSize:50];
    [self.TwoDimensionCodeView addSubview:centerLabel];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, centerLabel.top - 60, BLEJWidth, 25)];
    // 用户名
    topLabel.text = self.userModel.trueName;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont boldSystemFontOfSize:25];
    [self.TwoDimensionCodeView addSubview:topLabel];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(BLEJWidth * 0.4, topLabel.top - BLEJWidth * 0.2 - 10, BLEJWidth * 0.2, BLEJWidth * 0.2)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.userModel.photo] placeholderImage:[UIImage imageNamed:@"construction"]];
//    iconView.backgroundColor = kRandomColor;
    
    [self.TwoDimensionCodeView addSubview:iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, codeView.bottom + 20, BLEJWidth, 30)];
    label.text = @"截屏保存到相册:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    [self.TwoDimensionCodeView addSubview:label];
    
    UILabel *labelBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 10, BLEJWidth, 30)];
    labelBottom.text = @"在微信环境下按住图片识别二维码打开";
    labelBottom.textColor = [UIColor darkGrayColor];
    labelBottom.textAlignment = NSTextAlignmentCenter;
    labelBottom.font = [UIFont systemFontOfSize:16];
    [self.TwoDimensionCodeView addSubview:labelBottom];
    
    self.TwoDimensionCodeView.hidden = YES;
}

- (void)didClickShadowView:(UITapGestureRecognizer *)tap {
    
    self.tabBarController.tabBar.hidden = NO;
    self.TwoDimensionCodeView.hidden = YES;
    self.navigationController.navigationBar.alpha = 1;
}



- (ShareView*)shareView {
    
    if (!_shareView) {
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        __weak MeViewController *weakSelf = self;
        
        //        关闭
        _shareView.closeBlock = ^(){
            
            weakSelf.shareView.hidden = YES;
        };
        
        //        微信
        _shareView.weChatBlock = ^(){
            [weakSelf shareToWXSession];
        };
        
        //        朋友圈
        _shareView.timeLineBlock = ^(){
            [weakSelf shareToTimeLine];
        };
        
        //        QQ
        _shareView.QQBlock = ^(){
            [weakSelf shareToQQSession];
        };
        
        //        空间
        _shareView.QQZoneBlock = ^(){
            [weakSelf shareToQQZone];
        };
        //        二维码
//        _shareView.QRCodeBlock = ^(){
//            [weakSelf shareToQRCode];
//        };
        
//        _shareView.hidden = YES;
    }
    
    return _shareView;
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom,kSCREEN_WIDTH, kSCREEN_HEIGHT-self.navigationController.navigationBar.height-49) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = kBackgroundColor;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorColor = kSepLineColor;
    
    [self.view addSubview:tableView];
    
    self.UserTableView = tableView;
    
    [self.UserTableView registerNib:[UINib nibWithNibName:@"UserLogoTableViewCell" bundle:nil] forCellReuseIdentifier:@"UserLogoTableViewCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    } else if (section == 1) {
        
        return 6;
//        return 4;
    } else if (section == 2) {
        
        return 5;
    } else {
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        return 20;
    }
    return 10;
//    if (section == 0 || section == 1 || section == 2) {
//        return 5;
//    }
//    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    return [[UIView alloc] init];
//}
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
//    view.backgroundColor = Bottom_Color;
//    
//    return view;
//    
////    if (section == 0) {
////        
////        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
////        view.backgroundColor = Bottom_Color;
////        
////        return view;
////    }
////    
////    return [[UIView alloc]init];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 60;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UserLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserLogoTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) weakSelf = self;
        if (_isLogined == NO) {
            
            cell.NameLabel.hidden = YES;
            cell.MemberNumberLabel.hidden = YES;
            cell.RegAndLoginBtn.hidden = NO;
            cell.genderImageView.hidden = YES;
            
            cell.regAndLoginBlock = ^(){
                
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
            };
            
            [cell.LogoImageView setImage:[UIImage imageNamed:@"defaultman"]];
            
            cell.logoBlock = ^{
                
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                [weakSelf.navigationController pushViewController:loginVC animated:YES];
            };
            
            
            // 员工号码通
            cell.vipButton.hidden = YES;
            
        } else {
            cell.NameLabel.hidden = NO;
            cell.MemberNumberLabel.hidden = NO;
            cell.RegAndLoginBtn.hidden = YES;
            cell.genderImageView.hidden = NO;
            
            cell.NameLabel.text = self.userModel.trueName;
            NSNumber *agencyId = [NSNumber numberWithInteger:self.userModel.agencyId];
            cell.MemberNumberLabel.text = [NSString stringWithFormat:@"会员号：%@",agencyId];
            
            UIImage *temDefaultImg;
            if (self.userModel.gender == 0) {
                cell.genderImageView.image = [UIImage imageNamed:@"woman"];
                temDefaultImg = [UIImage imageNamed:DefaultWomenPic];
            }else{
                cell.genderImageView.image = [UIImage imageNamed:@"man"];
                temDefaultImg = [UIImage imageNamed:DefaultManPic];
            }
            
            
            
            NSURL *imgUrl = [NSURL URLWithString:self.userModel.photo];
            [cell.LogoImageView sd_setImageWithURL:imgUrl placeholderImage:temDefaultImg];
            
            cell.logoBlock = ^{
                PersonalInfoViewController *personVC = [[PersonalInfoViewController alloc]init];
                [self.navigationController pushViewController:personVC animated:YES];
            };
            
            // 员工号码通
            cell.vipButton.hidden = NO;
            __block NSInteger isVip = [self.vipDic[@"isVip"] integerValue] > 0 ? 1 : 0;
            __block NSString *companyId = self.vipDic[@"companyId"];
            [cell.vipButton setImage: (isVip == 1) ? [UIImage imageNamed:@"note1"] : [UIImage imageNamed:@"note"] forState:UIControlStateNormal];
            cell.vipActionBlock = ^{
                ZCHCalculatorPayController *VC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
                VC.isNotCompany = YES;
                VC.companyId = companyId.length > 0 ? companyId : @"0";
                VC.type = [NSString stringWithFormat:@"%ld", isVip]; // // 0: 新开通  1: 续费
                VC.refreshBlock = ^() {
                    [weakSelf requestVip];
                };
                [weakSelf.navigationController pushViewController:VC animated:YES];
            };
            
        }
        
        return cell;
        
    } else {
        
        NSString *cellIdentifier2 = @"Second";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
        }
        cell.contentView.backgroundColor = White_Color;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"我的公司",@"我的工地",@"我的美文",@"我的名片",@"我的代金券",@"商户联盟", @"我的收藏",@"消息中心",@"使用说明",@"推荐给朋友",@"设置",@"意见反馈", nil];
//        NSArray *titleArray = [NSArray arrayWithObjects:@"我的公司",@"我的工地",@"我的美文",@"我的名片",@"商户联盟", @"我的收藏",@"消息中心",@"使用说明",@"推荐给朋友",@"设置",@"意见反馈", nil];
        if (indexPath.section == 1) {
            
            cell.textLabel.text = titleArray[indexPath.row];
        } else if (indexPath.section == 2) {
            
            cell.textLabel.text = titleArray[indexPath.row + 6];
//            cell.textLabel.text = titleArray[indexPath.row + 4];
        } else {
            
            cell.textLabel.text = titleArray[indexPath.row + 11];
//            cell.textLabel.text = titleArray[indexPath.row + 9];
        }
        
        
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        
        if (indexPath.section == 2 && indexPath.row == 1) {
            UILabel *label = [[UILabel alloc] init];
            self.messageFlagLabel = label;
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 10;
            label.layer.masksToBounds = YES;
            label.clipsToBounds = YES;
            label.tag = 1000;
            label.text = @"0";
            self.messageFlagLabel.hidden = !(label.text.integerValue > 0);
        } else {
            if (self.messageFlagLabel) {
                self.messageFlagLabel.hidden = YES;
            }
        }
        
        if (indexPath.section ==2 && indexPath.row == 2) {

            NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:@"使用说明" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
            NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:@"不知道如何使用 进入查看" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: Red_Color}];
            NSMutableAttributedString *mulAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr1];
            [mulAttr appendAttributedString:attr2];
            cell.textLabel.attributedText = mulAttr;
        
            if (!self.useExplainFlagView) {
                self.useExplainFlagView = [[UIImageView alloc] init];
            }
            
            
            if (IPhone5) {
                [cell addSubview:self.useExplainFlagView];
                
                [self.useExplainFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(CGSizeMake(32, 32));
                    make.right.equalTo(kSize(-12));
                    make.centerY.equalTo(0);
                }];
                self.useExplainFlagView.backgroundColor = [UIColor whiteColor];
            } else {
                [cell.contentView addSubview:self.useExplainFlagView];
                [self.useExplainFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.equalTo(CGSizeMake(32, 32));
                    make.right.equalTo(-8);
                    make.centerY.equalTo(0);
                }];
            }
            self.useExplainFlagView.image = [UIImage imageNamed:@"useExplain_flag"];

            
            self.useExplainFlagView.hidden = YES;
            // 使用说明红点提示是否显示
            BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
            //    isReade = NO;
            //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kuseExplainFlag];
            //    [[NSUserDefaults standardUserDefaults] synchronize];
            if (kHasUseExpalinUpdate && !isReade) {
                self.useExplainFlagView.hidden = NO;
            } else {
                self.useExplainFlagView.hidden = YES;
            }
        }
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (_isLogined == NO) {
            
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            
            PersonalInfoViewController *personVC = [[PersonalInfoViewController alloc]init];
            [self.navigationController pushViewController:personVC animated:YES];
        }
    }
    
    if (indexPath.section > 0) {
        
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                    
                    // 我的公司
                case 0:
                {
                    
                    if (_isLogined == YES) {
                        [self getCompanyList];
                        
                        
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                }
                    break;
                    
                    // 我的工地
                case 1:
                {
                    if (_isLogined == YES) {
                        
                        MyConstructionSiteViewController *siteVC = [[MyConstructionSiteViewController alloc]init];
                        [self.navigationController pushViewController:siteVC animated:YES];
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                    
                }
                    break;
                // 我的美文
                case 2:
                {
                    if (_isLogined == YES) {
                        
                        MyBeautifulArtController *siteVC = [[MyBeautifulArtController alloc]init];
//                        ShopUnionListController *siteVC = [[ShopUnionListController alloc]init];
                        [self.navigationController pushViewController:siteVC animated:YES];
                        
//                        [self requestUninPower];
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                    
                }
                break;
                case 3:
                {// 我的名片
                    if (_isLogined == YES) {
                        UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                        NSInteger agencyid = user.agencyId;
                        if (!agencyid||agencyid == 0) {
                            agencyid = 0;
                        }
                        NewMyPersonCardController *personCard = [[NewMyPersonCardController alloc] init];
                        personCard.agencyId = [NSString stringWithFormat:@"%ld", agencyid];
                        [self.navigationController pushViewController:personCard animated:YES];

                    }else{

                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }

                }
                    break;
                case 4:
                {// 我的代金券
                    if (_isLogined == YES) {
                        STYMyCashCouponController *vc = [[STYMyCashCouponController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    } else {

                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                }
                    break;
                    
                case 5:
                {// 商户联盟
                    if (_isLogined == YES) {
                        
                        //                        CreatShopUnionController *siteVC = [[CreatShopUnionController alloc]init];
                        //                        ShopUnionListController *siteVC = [[ShopUnionListController alloc]init];
                        //                        [self.navigationController pushViewController:siteVC animated:YES];
                        
                        [self requestUninPower];
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }
        
        
        if (indexPath.section == 2) {
            
            switch (indexPath.row) {
                case 0:
                {// 收藏店铺
                    if (_isLogined == YES) {
                        
                        CollectionViewController *vC = [[CollectionViewController alloc]init];
                        
                        [self.navigationController pushViewController:vC animated:YES];
                        
                        
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                    
                }
                    break;
                    
                case 1:
                {// 消息中心
                    if (_isLogined == YES) {
                        
                        MessageCenterViewController *messageVC = [[MessageCenterViewController alloc]init];
                        
                        [self.navigationController pushViewController:messageVC animated:YES];
                        
                        
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                    
                }
                    break;
                    
                case 3:
                {// 推荐给朋友
                    [MobClick event:@"TuiJianShare"];
                    self.shareView.hidden = NO;
                }
                    break;
                    
                case 2:
                {// 帮助中心
                    // 使用说明设置为已读， 隐藏红点
                    self.useExplainFlagView.hidden = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kuseExplainFlag];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    SpecificationViewController *specificationVC = [[SpecificationViewController alloc]init];
                    [self.navigationController pushViewController:specificationVC animated:YES];
                    
                }
                    break;
                    
                case 4:
                {// 设置
                    if (_isLogined == YES) {
                        
                        SettingViewController *settingVC = [[SettingViewController alloc]init];
                        [self.navigationController pushViewController:settingVC animated:YES];
                        
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            
        
        if (indexPath.section == 3) {
            
            switch (indexPath.row) {
             
                    //                意见反馈
                case 0:
                {
                    if (_isLogined == YES) {
                        
                        feedbackVC *settingVC = [[feedbackVC alloc]init];
                        [self.navigationController pushViewController:settingVC animated:YES];
                        
                    }else{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc]init];
                        [self.navigationController pushViewController:loginVC animated:YES];
                    }
                }
                    break;
                
                default:
                    break;
                    
            }
        }
    }
}


- (void)getCompanyList {
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    //    NSString *str = @"http://192.168.0.119:8080/blej-api-blej/api/";
    NSString *requestString = [BASEURL stringByAppendingString:@"company/findCompanyList.do"];
    NSDictionary *dic = @{@"agencysId":@(user.agencyId)
                          };
    //    NSDictionary *dic = @{@"companyId":@267};
    [self.view hudShow];
    [NetManager afPostRequest:requestString parms:dic finished:^(id responseObj) {
//        NSLog(@"%@",responseObj);
        [self.view hiddleHud];
        if ([responseObj[@"code"] isEqualToString:@"1001"]) {
            //该用户还未加入公司
            CreateCompanyViewController *vc = [[CreateCompanyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if ([responseObj[@"code"] isEqualToString:@"1000"]) {
//            NSDictionary *dict = responseObj[@"data"];
//            [self setDataWithDict:dict];
            MyCompanyViewController *companyVC = [[MyCompanyViewController alloc]init];
            [self.navigationController pushViewController:companyVC animated:YES];
        }
        if ([responseObj[@"code"] isEqualToString:@"1002"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您还没有公司，如果您是总经理请创建公司，其他职位请申请加入公司。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"创建公司", @"加入公司",nil];
            alert.tag = 100;
            [alert show];
            
//            if ([user.registJob integerValue]==1002) {
//                //提示创建公司
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"你还没有创建公司，是否创建新公司？"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"否"
//                                                      otherButtonTitles:@"是",nil];
//                alert.tag = 100;
//                [alert show];
//                
//                
//            }
//            else{
//                //不是总经理,提示申请加入公司
//                //该用户还没有加入公司
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"你还没有加入公司，是否加入新公司？"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"否"
//                                                      otherButtonTitles:@"是",nil];
//                alert.tag = 200;
//                [alert show];
//            }
            
        }
        if ([responseObj[@"code"] isEqualToString:@"2000"]){
            [[PublicTool defaultTool] publicToolsHUDStr:@"查询出现错误" controller:self sleep:2.0];
        }
        //        [_mainTableView reloadData];
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
        [self.view hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:self sleep:2.0];
    }];
}

-(void)applictionTip{
    [[PublicTool defaultTool] publicToolsHUDStr:@"公司申请成功，请等待审核" controller:self sleep:2.0];
}

#pragma  mark - 查询员工短息通vip信息
- (void)requestVip {
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"salesman/getVipInfo.do"];
    NSDictionary *paramDic = @{@"agencyId":@(user.agencyId),
                               @"companyId": @(0)
                               };
    
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if ([(NSString *)responseObj[@"code"] integerValue] == 1000) {
            self.vipDic = responseObj[@"data"][@"vipInfo"];
        }
        [self.UserTableView reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}
#pragma mark - 查询联盟相关权限

-(void)requestUninPower{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getJurisdiction.do"];
    
    
    NSDictionary *paramDic = @{@"agencysId":@(user.agencyId)
                               };
    [[UIApplication sharedApplication].keyWindow hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            _isZongjingli = [responseObj[@"isZongjingli"] boolValue];
            //_isJingLi = [responseObj[@"isJingLi"] boolValue];
            implement = [responseObj[@"implement"]boolValue];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            
            if (statusCode==1000) {
                //进入联盟
                NSArray *array = responseObj[@"union"];
                [self.unionArray removeAllObjects];
                [self.unionArray addObjectsFromArray:array];
//                if (array&&array.count>0) {
//                    NSDictionary *dict = array.firstObject;
//                    NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
//                    [self requestUnionDetailInfoWith:unionId];
//                }
                
                NSArray *companyArray = responseObj[@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[UnionCompanyModel class] json:companyArray];
                [self.companyArray removeAllObjects];
                [self.companyArray addObjectsFromArray:arr];
                if (_isZongjingli||implement) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"请选择创建或申请加入联盟或查看联盟"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"创建联盟", @"加入联盟",@"查看联盟",nil];
                    alert.tag = 300;
                    [alert show];
                }
//                else if (_isJingLi) {
//                    //选择加入联盟或查看联盟
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"请选择加入联盟或查看联盟"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"取消"
//                                                          otherButtonTitles:@"加入联盟",@"查看联盟",nil];
//                    alert.tag = 400;
//                    [alert show];
//                }
                else{
                    
                    //是否有联盟列表
                    if (self.unionArray&&self.unionArray.count>0){
                        //只能查看联盟---直接查看
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                        message:@"请选择查看联盟"
//                                                                       delegate:self
//                                                              cancelButtonTitle:@"取消"
//                                                              otherButtonTitles:@"查看联盟",nil];
//                        alert.tag = 500;
//                        [alert show];
                        
                        NSMutableArray *temArray = [NSMutableArray array];
                        for (NSDictionary *dict in self.unionArray) {
                            NSString  *unionName = [dict objectForKey:@"unionName"];
                            [temArray addObject:unionName];
                        }
                        
                        SSPopup* selection=[[SSPopup alloc]init];
                        selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                        
                        selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                        selection.SSPopupDelegate=self;
                        [self.view addSubview:selection];
                        
                        
                        NSArray *QArray = [temArray copy];
                        
                        [selection CreateTableview:QArray withTitle:@"请选择查看联盟" setCompletionBlock:^(int tag) {
                            YSNLog(@"%d",tag);
                            
                            NSDictionary *dict = self.unionArray[tag];
                            NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
                            [self requestUnionDetailInfoWith:unionId];
                        }
                         ];
                    }
                    else{
                        [[PublicTool defaultTool] publicToolsHUDStr:@"该公司还未加入联盟" controller:self sleep:1.5];
                    }
                    
                }
                
            }
            else if (statusCode==1001) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==1002) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您还未加入公司" controller:self sleep:2.0];
            }
//            else if (statusCode==1003) {
//
//                NSArray *companyArray = responseObj[@"companyList"];
//                NSArray *arr = [NSArray yy_modelArrayWithClass:[UnionCompanyModel class] json:companyArray];
//                [self.companyArray removeAllObjects];
//                [self.companyArray addObjectsFromArray:arr];
//                if (_isZongjingli) {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"您还没有联盟，请选择创建或加入联盟"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"取消"
//                                                          otherButtonTitles:@"创建联盟", @"加入联盟",nil];
//                    alert.tag = 300;
//                    [alert show];
//                }
//                if (_isJingLi) {
//                    //选择加入联盟
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                    message:@"您还没有联盟，请选择加入联盟"
//                                                                   delegate:self
//                                                          cancelButtonTitle:@"取消"
//                                                          otherButtonTitles:@"加入联盟",nil];
//                    alert.tag = 400;
//                    [alert show];
//                }
//
//            }
            else if (statusCode==1004) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"该公司还未加入联盟" controller:self sleep:2.0];
            }
            else if (statusCode==1005) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"您没有分公司" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        YSNLog(@"%@",errorMsg);
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
    }];
}

#pragma mark - 查询联盟详情
-(void)requestUnionDetailInfoWith:(NSInteger)unionId{
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"union/getListByCreatePerson.do"];
    
    [[UIApplication sharedApplication].keyWindow hudShow];
    NSDictionary *paramDic = @{@"unionId":@(unionId),
                               @"agencysId":@(user.agencyId)
                               };
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            [[UIApplication sharedApplication].keyWindow hiddleHud];
            NSInteger statusCode = [(NSString *)responseObj[@"code"] integerValue];
            if (statusCode==1000) {
                NSArray *array = responseObj[@"data"];
                NSDictionary *temDict = array.firstObject;
                NSArray *tempArray = [temDict objectForKey:@"companyList"];
                NSArray *arr = [NSArray yy_modelArrayWithClass:[ShopUnionListModel class] json:tempArray];
                NSMutableArray *dataArray = [NSMutableArray array];
                [dataArray addObjectsFromArray:arr];
                
                NSString *unionLogo = temDict[@"unionLogo"];
                NSString *unionNumber = temDict[@"unionNumber"];
                NSString *unionName = temDict[@"unionName"];
                NSString *unionId = temDict[@"unionId"];
                NSString *unionPwd = temDict[@"unionPwd"];
                if (!unionPwd) {
                    unionPwd = @"111111";
                }
                BOOL isLeader = [temDict[@"isLeader"] boolValue];
                BOOL isZManage = [temDict[@"zjl"] boolValue];
                BOOL isFManage = [temDict[@"jl"] boolValue];
                
                ShopUnionListController *vc = [[ShopUnionListController alloc]init];
                vc.dataArray = dataArray;
                vc.unionLogo = unionLogo;
                vc.unionNumber = unionNumber;
                vc.unionName = unionName;
                vc.unionPwd = unionPwd;
                vc.unionId = [unionId integerValue];
                vc.isLeader = isLeader;
                vc.isZManage = isZManage;
                vc.isFManage = isFManage;
                [self.navigationController pushViewController:vc animated:YES];
               
            }
            else if (statusCode==1001) {
                //                NSArray *arr = [NSArray yy_modelArrayWithClass:[CaseMaterialTwoModel class] json:caseArr];
                [[PublicTool defaultTool] publicToolsHUDStr:@"参数错误" controller:self sleep:2.0];
            }
            else if (statusCode==2000) {
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
            }
            
        }
        
        //        NSLog(@"%@",responseObj);
    } failed:^(NSString *errorMsg) {
        [[UIApplication sharedApplication].keyWindow hiddleHud];
        [[PublicTool defaultTool] publicToolsHUDStr:@"请求失败" controller:self sleep:2.0];
        YSNLog(@"%@",errorMsg);
    }];
}

#pragma mark - 获取消息数量

- (void)getMessageNumData {
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        UserLogoTableViewCell *cell = [self.UserTableView cellForRowAtIndexPath:indexPath];
        UILabel *label = [cell.contentView viewWithTag:1000];
        // 设置消息中心消息数量表示
        NSString *numStr ;
        // 消息数量添加 使用说明提示
//        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
//        if (kHasUseExpalinUpdate && !isReade) {
             numStr = [NSString stringWithFormat:@"%ld", self.messageNum];
//        } else {
//            numStr = [NSString stringWithFormat:@"%ld", self.messageNum];
//        }
        
        
        label.text = numStr;
        label.hidden = !(label.text.integerValue > 0);
        
        if ([label.text isEqualToString:@"99+"] || label.text.integerValue > 9) {
            CGSize size = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) withFont:[UIFont systemFontOfSize:13]];
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(size.width + 10, 20));
            }];
        } else {
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
        }
    }
}

- (void)getMessageNumDataWithNetWork {
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                if (code == 1000) {
                    NSDictionary *numDic = [responseObj objectForKey:@"data"];
                    self.messageNum = [numDic[@"total"] integerValue];
                    self.messageNum += totalUnreadCount;
                   
                    // 消息数量添加 使用说明提示
                    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                    if (kHasUseExpalinUpdate && !isReade) {
                        NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)self.messageNum + 1];
                        if (messageNUMStr.integerValue > 99) {
                            self.tabBarItem.badgeValue = @"99+";
                        } else if (messageNUMStr.integerValue > 0) {
                            self.tabBarItem.badgeValue = messageNUMStr;
                        } else {
                            self.tabBarItem.badgeValue = nil;
                        }
                        [UIApplication sharedApplication].applicationIconBadgeNumber = self.messageNum + 1;
                    } else {
                        NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)self.messageNum];
                        if (self.messageNum > 99) {
                            self.tabBarItem.badgeValue = @"99+";
                        } else if (self.messageNum > 0) {
                            self.tabBarItem.badgeValue = messageNUMStr;
                        } else {
                            self.tabBarItem.badgeValue = nil;
                        }
                        [UIApplication sharedApplication].applicationIconBadgeNumber = self.messageNum;
                    }
                    if (self.messageNum == 0) {
                        [JPUSHService resetBadge];
                    }
                    [self getMessageNumData];
                } else {
                    NSDictionary *numDic = [responseObj objectForKey:@"data"];
                    self.messageNum = [numDic[@"total"] integerValue];
                    self.messageNum += totalUnreadCount;
                    
                    
                    // 消息数量添加 使用说明提示
                    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                    if (kHasUseExpalinUpdate && !isReade) {
                        NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)self.messageNum + 1];
                        if (messageNUMStr.integerValue > 99) {
                            self.tabBarItem.badgeValue = @"99+";
                        } else if (messageNUMStr.integerValue > 0) {
                            self.tabBarItem.badgeValue = messageNUMStr;
                        } else {
                            self.tabBarItem.badgeValue = nil;
                        }
                        [UIApplication sharedApplication].applicationIconBadgeNumber = self.messageNum + 1;
                    } else {
                        NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)self.messageNum];
                        if (self.messageNum > 99) {
                            self.tabBarItem.badgeValue = @"99+";
                        } else if (self.messageNum > 0) {
                            self.tabBarItem.badgeValue = messageNUMStr;
                        } else {
                            self.tabBarItem.badgeValue = nil;
                        }
                        [UIApplication sharedApplication].applicationIconBadgeNumber = self.messageNum;
                    }
                    
                    if (self.messageNum == 0) {
                        [JPUSHService resetBadge];
                    }
                    [self getMessageNumData];
                }
            });
            
            
           
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
            self.tabBarItem.badgeValue = @"1";
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        } else {
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        }
        
    }
}



- (void)clearMessageNum {
    self.messageNum = 0;
    self.tabBarItem.badgeValue = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
    UserLogoTableViewCell *cell = [self.UserTableView cellForRowAtIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:1000];
    label.text = @"0";
    label.hidden = YES;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // 消息数量添加 使用说明提示
    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
    if (kHasUseExpalinUpdate && !isReade) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        self.tabBarItem.badgeValue = @"1";
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==100) {
        if (buttonIndex == 1) {
            CreateCompanyViewController *vc = [[CreateCompanyViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (buttonIndex == 2) {
            JoinCompanyController *vc = [[JoinCompanyController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (alertView.tag==200) {
        if (buttonIndex == 1) {
            JoinCompanyController *vc = [[JoinCompanyController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (alertView.tag == 300) {
        if (buttonIndex == 1) {
            //创建联盟
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            NSMutableArray *temArray = [NSMutableArray array];
            for (UnionCompanyModel *model in self.companyArray) {
                [temArray addObject:model.companyName];
            }
            
            NSArray *QArray = [temArray copy];
            
            [selection CreateTableview:QArray withTitle:@"请选择联盟所属公司" setCompletionBlock:^(int tag) {
                YSNLog(@"%d",tag);
                CreatShopUnionController *vc =[[CreatShopUnionController alloc]init];
                //        vc.areaListArray = self.areaListArray;
                UnionCompanyModel *model = self.companyArray[tag];
                vc.companyId = model.companyId;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
             ];
            
//            CreatShopUnionController *vc = [[CreatShopUnionController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        if (buttonIndex == 2) {
//            JoinCompanyController *vc = [[JoinCompanyController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            // 申请加入联盟
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            NSMutableArray *temArray = [NSMutableArray array];
            for (UnionCompanyModel *model in self.companyArray) {
                [temArray addObject:model.companyName];
            }
            
            NSArray *QArray = [temArray copy];
            
            [selection CreateTableview:QArray withTitle:@"请选择联盟所属公司" setCompletionBlock:^(int tag) {
                YSNLog(@"%d",tag);
                SearchUnionController *vc =[[SearchUnionController alloc]init];
//                //        vc.areaListArray = self.areaListArray;
                UnionCompanyModel *model = self.companyArray[tag];
                vc.companyId = model.companyId;
                vc.companyName = model.companyName;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
             ];
            
        }
        
        if (buttonIndex==3) {
            //查看联盟
            if (self.unionArray&&self.unionArray.count>0) {
                NSMutableArray *temArray = [NSMutableArray array];
                for (NSDictionary *dict in self.unionArray) {
                    NSString  *unionName = [dict objectForKey:@"unionName"];
                    [temArray addObject:unionName];
                }
                
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                
                NSArray *QArray = [temArray copy];
                
                [selection CreateTableview:QArray withTitle:@"请选择查看联盟" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    
                    NSDictionary *dict = self.unionArray[tag];
                    NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
                    [self requestUnionDetailInfoWith:unionId];
                }
                 ];
            
//                [self requestUnionDetailInfoWith:unionId];
                
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无联盟，请选择加入或创建联盟" controller:self sleep:2.0];
            }
        }
    }
    
    if (alertView.tag == 400){
        if (buttonIndex == 1){
            SSPopup* selection=[[SSPopup alloc]init];
            selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
            
            selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
            selection.SSPopupDelegate=self;
            [self.view addSubview:selection];
            NSMutableArray *temArray = [NSMutableArray array];
            for (UnionCompanyModel *model in self.companyArray) {
                [temArray addObject:model.companyName];
            }
            
            NSArray *QArray = [temArray copy];
            
            [selection CreateTableview:QArray withTitle:@"请选择联盟所属公司" setCompletionBlock:^(int tag) {
                YSNLog(@"%d",tag);
                SearchUnionController *vc =[[SearchUnionController alloc]init];
                //                //        vc.areaListArray = self.areaListArray;
                UnionCompanyModel *model = self.companyArray[tag];
                vc.companyId = model.companyId;
                vc.companyName = model.companyName;
                //
                [self.navigationController pushViewController:vc animated:YES];
                
            }
             ];
        }
        if (buttonIndex==2) {
            //查看联盟
            if (self.unionArray&&self.unionArray.count>0) {
                NSMutableArray *temArray = [NSMutableArray array];
                for (NSDictionary *dict in self.unionArray) {
                    NSString  *unionName = [dict objectForKey:@"unionName"];
                    [temArray addObject:unionName];
                }
                
                SSPopup* selection=[[SSPopup alloc]init];
                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
                
                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
                selection.SSPopupDelegate=self;
                [self.view addSubview:selection];
                
                
                NSArray *QArray = [temArray copy];
                
                [selection CreateTableview:QArray withTitle:@"请选择查看联盟" setCompletionBlock:^(int tag) {
                    YSNLog(@"%d",tag);
                    
                    NSDictionary *dict = self.unionArray[tag];
                    NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
                    [self requestUnionDetailInfoWith:unionId];
                }
                 ];
                
                //                [self requestUnionDetailInfoWith:unionId];
                
            }
            else{
                [[PublicTool defaultTool] publicToolsHUDStr:@"暂无联盟，请选择加入联盟" controller:self sleep:2.0];
            }
        }
    }
    
//    if (alertView.tag==500) {
//        if (buttonIndex==1) {
//            //查看联盟
//            if (self.unionArray&&self.unionArray.count>0) {
//                NSMutableArray *temArray = [NSMutableArray array];
//                for (NSDictionary *dict in self.unionArray) {
//                    NSString  *unionName = [dict objectForKey:@"unionName"];
//                    [temArray addObject:unionName];
//                }
//
//                SSPopup* selection=[[SSPopup alloc]init];
//                selection.backgroundColor = [UIColor colorWithWhite:0.00 alpha:0.4];
//
//                selection.frame = CGRectMake(0,0,kSCREEN_WIDTH,kSCREEN_HEIGHT);
//                selection.SSPopupDelegate=self;
//                [self.view addSubview:selection];
//
//
//                NSArray *QArray = [temArray copy];
//
//                [selection CreateTableview:QArray withTitle:@"请选择查看联盟" setCompletionBlock:^(int tag) {
//                    YSNLog(@"%d",tag);
//
//                    NSDictionary *dict = self.unionArray[tag];
//                    NSInteger unionId = [[dict objectForKey:@"unionId"] integerValue];
//                    [self requestUnionDetailInfoWith:unionId];
//                }
//                 ];
//
//                //                [self requestUnionDetailInfoWith:unionId];
//
//            }
//        }
//    }
    
    
}

//分享到对话
- (void)shareToWXSession {
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = @"爱装修";
    message.description = @"爱装修";
    //    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.blej.chaojiguanliyuan";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

//分享到朋友圈
-(void)shareToTimeLine{
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = @"爱装修";
    message.description = @"爱装修";
    //    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.blej.chaojiguanliyuan";
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

//分享到QQ
-(void)shareToQQSession{
    
    if ([TencentOAuth iphoneQQInstalled]) {
        
        //声明一个新闻类对象
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
        //从contentObj中传入数据，生成一个QQReq
        NSURL *url = [NSURL URLWithString:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.blej.chaojiguanliyuan"];
        QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"爱装修" description:@"爱装修" previewImageURL:nil];
        //向QQ发送消息，查看是否可以发送
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
        QQApiSendResultCode code = [QQApiInterface sendReq:req];
        NSLog(@"%d",code);
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到AppStore下载最新版本手机QQ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

//分享到QQ空间
-(void)shareToQQZone{
    
    if ([TencentOAuth iphoneQQInstalled]){
        
        //声明一个新闻类对象
        self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:nil];
        //从contentObj中传入数据，生成一个QQReq
        NSURL *url = [NSURL URLWithString:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.blej.chaojiguanliyuan"];
        QQApiNewsObject *newObject = [QQApiNewsObject objectWithURL:url title:@"爱装修" description:@"爱装修" previewImageURL:nil];
        //向QQ发送消息，查看是否可以发送
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newObject];
        QQApiSendResultCode code = [QQApiInterface SendReqToQZone:req];
        NSLog(@"%d",code);
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请到AppStore下载最新版本手机QQ" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


-(void)refreshState:(NSNotificationCenter*)sender{
    
    _isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    [self.UserTableView reloadData];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
