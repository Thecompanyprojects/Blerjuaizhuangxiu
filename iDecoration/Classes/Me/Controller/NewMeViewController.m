//
//  NewMeViewController.m
//  iDecoration
//
//  Created by 丁 on 2018/4/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NewMeViewController.h"
#import "NewMeCell.h"
#import "LoginViewController.h"
#import "SpecificationViewController.h"
#import "CollectionViewController.h"
#import "SettingViewController.h"
#import "feedbackVC.h"
#import "ShareView.h"
#import "SystemMessageViewController.h"
#import "PersonalInfoViewController.h"
#import "ZCHCalculatorPayController.h"
#import "DistributionViewController.h"
#import "DistributionControlVC.h"
#import <JPUSHService.h>
#import "mywalletVC.h"
#import "MyOrderViewController.h"
#import "RemindViewController.h"
#import "ZCHPublicWebViewController.h"
#import "InstructionsViewController.h"
#import "ExcellentCaseViewController.h"
#import "ZCHPublicWebViewController.h"
@interface NewMeViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>
{
    BOOL _isLogined;
    BOOL ischoose;//分销是否通过审核
}

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *personalIcon;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ShareView *shareView;

@property (nonatomic, strong) UIImageView *useExplainFlagView;
@property (nonatomic, strong) UserInfoModel *userModel;
@property (nonatomic, strong) NSMutableDictionary *vipDic;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, strong) UILabel *personalNameLabel;
@property (nonatomic, strong) UILabel *vipNumLabel;
@property (nonatomic, strong) UIButton *vipBtn;

//  系统消息和聊天消息总数
@property (nonatomic, assign) NSInteger messageNum;

@property (nonatomic, assign) NSInteger systemMessageNum; // 系统消息数量
@property (nonatomic, assign) NSInteger chatMessageNum; // 聊天消息数量

@property (nonatomic,strong) UIImageView *zhiimg;
@end

@implementation NewMeViewController

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    ischoose = NO;
    [self requestVip];
    _isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    
    NSString *defaultImageName = @"defaultLogo";
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:@"impl"];
    
    if ([num isEqual:@1]) {
        [self.zhiimg setHidden:NO];
    }
    else
    {
        [self.zhiimg setHidden:YES];
    }
    
    if (_isLogined == YES) {
        if (self.userModel.gender == 0) {
            defaultImageName = @"defaultwomen";
        }else{
            defaultImageName = @"defaultman";
        }
        self.userModel = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        self.personalNameLabel.text = self.userModel.trueName;
        [self.personalIcon sd_setImageWithURL:[NSURL URLWithString:self.userModel.photo] placeholderImage:[UIImage imageNamed:defaultImageName]];
    } else {
        self.personalIcon.image = [UIImage imageNamed:defaultImageName];
        self.personalNameLabel.text = @"未登录";
    }
    // 使用说明红点提示是否显示
    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
    if (kHasUseExpalinUpdate && !isReade) {
        self.useExplainFlagView.hidden = NO;
    } else {
        self.useExplainFlagView.hidden = YES;
    }
    
    self.vipNumLabel.hidden = !_isLogined;
    self.vipBtn.hidden = !_isLogined;
    
    [self getMessageNumDataWithNetWork];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    [self buildView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshState:) name:@"refreshUserState" object:nil];
    
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


-(void)applictionTip{
    [[PublicTool defaultTool] publicToolsHUDStr:@"公司申请成功，请等待审核" controller:self sleep:2.0];
}

// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    if (isShowHomePage) {
        [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
    } else {
        BOOL isLoginVC = [viewController isKindOfClass:[LoginViewController class]];
        if (isLoginVC) {
            [self.navigationController setNavigationBarHidden:isLoginVC animated:YES];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}

- (void)buildView {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 98 + 41)];
    if (IphoneX) {
        v.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 41 + 98 + 22);
    }
    v.backgroundColor = [UIColor clearColor];
    UIImageView *topView = [[UIImageView alloc] init];
    [v addSubview:topView];
    self.topView = topView;
    UIImage *imageBG = [UIImage imageNamed:@"bg_me"];
    if (IphoneX) {
        imageBG = [[UIImage imageNamed:@"bg_me"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 194, 0) resizingMode:UIImageResizingModeStretch];
        topView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 98 + 22);
    } else {
        
        topView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 98);
    }
    [self.view addSubview:v];
    topView.image = imageBG;
    topView.contentMode = UIViewContentModeScaleAspectFill;
    UILabel *titleLabel = [UILabel new];
    [topView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IphoneX) {
            make.top.equalTo(20 + 22);
        } else {
            make.top.equalTo(20);
        }
        make.centerX.equalTo(0);
    }];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"个人中心";
    
    NSString *defaultImageName = @"defaultLogo";
    
    self.personalIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:defaultImageName]];
    [v addSubview:self.personalIcon];
    [self.personalIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.centerY.equalTo(topView.mas_bottom);
        make.size.equalTo(CGSizeMake(82, 82));
    }];
    self.personalIcon.layer.cornerRadius = 41;
    self.personalIcon.layer.masksToBounds = YES;
    self.personalIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction)];
    [self.personalIcon addGestureRecognizer:tapAction];
}

#pragma mark - 登录
- (void)loginAction {
    if (_isLogined) {
        PersonalInfoViewController *pvc = [PersonalInfoViewController new];
        pvc.fromIndex = 0;
        pvc.agenceyId = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict].agencyId;
        [self.navigationController pushViewController:pvc animated:YES];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (void)vipBtnAction:(UIButton *)sender {
    ZCHCalculatorPayController *VC = [UIStoryboard storyboardWithName:@"ZCHCalculatorPayController" bundle:nil].instantiateInitialViewController;
    __block NSInteger isVip = [self.vipDic[@"isVip"] integerValue] > 0 ? 1 : 0;
    __block NSString *companyId = self.vipDic[@"companyId"];
    VC.isNotCompany = YES;
    VC.companyId = companyId.length > 0 ? companyId : @"0";
    VC.type = [NSString stringWithFormat:@"%ld", isVip]; // // 0: 新开通  1: 续费
    MJWeakSelf;
    VC.refreshBlock = ^() {
        [weakSelf requestVip];
    };
    [weakSelf.navigationController pushViewController:VC animated:YES];
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
        
        __block NSInteger isVip = [self.vipDic[@"isVip"] integerValue] > 0 ? 1 : 0;
        __block NSString *agencyId = [NSString stringWithFormat:@"%ld", self.userModel.agencyId] ;
        self.vipBtn.selected = isVip;
        self.vipNumLabel.text = [NSString stringWithFormat:@"会员号：%@", agencyId];
        
        [self.tableView reloadData];
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 获取消息数量
- (void)getMessageNumDataWithNetWork {
    self.messageNum = 0;
    self.chatMessageNum= 0;
    self.systemMessageNum = 0;
    
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
        
        self.chatMessageNum = totalUnreadCount;
        
        
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
                    self.systemMessageNum = [numDic[@"complain"] integerValue];
                    self.messageNum += self.systemMessageNum + self.chatMessageNum;
                    
                    // 没有任何消息也没有
                    if (([numDic[@"total"] integerValue] + self.chatMessageNum) == 0) {
                        [JPUSHService resetBadge];
                    }
                    
                    // 消息数量添加 使用说明提示
                    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
                    if (kHasUseExpalinUpdate && !isReade) {
                        self.messageNum += 1;
                    }
                    // 设置tabbarItem角标
                    NSString *messageNUMStr = [NSString stringWithFormat:@"%ld", (long)self.messageNum];
                    if (self.messageNum > 99) {
                        self.tabBarItem.badgeValue = @"99+";
                    } else if (self.messageNum > 0) {
                        self.tabBarItem.badgeValue = messageNUMStr;
                    } else {
                        self.tabBarItem.badgeValue = nil;
                    }
                    
                    
                    [self getMessageNumData];
                } else {
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

#pragma mark - 获取消息数量

- (void)getMessageNumData {
    if ([[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        NewMeCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        UILabel *label = cell.messageNumLabel;
        // 设置系统消息数量
        NSString *numStr ;
        numStr = [NSString stringWithFormat:@"%ld", self.systemMessageNum];
        
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

- (void)clearMessageNum {
    self.messageNum = 0;
    self.tabBarItem.badgeValue = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    NewMeCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = cell.messageNumLabel;
    label.text = @"0";
    label.hidden = YES;
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    // 消息数量添加 使用说明提示
    BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
    if (kHasUseExpalinUpdate && !isReade) {
        self.tabBarItem.badgeValue = @"1";
    } else {
        self.tabBarItem.badgeValue = @"0";
    }
}



#pragma mark - UItableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewMeCell" forIndexPath:indexPath];
    NSArray *imageNames = @[@"icon_shiyongshuoming",@"icon_anli_nor", @"icon_xitongxiaoxi",@"icon_liaotianxiaoxi",@"icon_commend", @"icon_yijianfankui",@"icon_zaixiankefu",@"icon_set"];
    NSArray *titleNames = @[@"使用说明", @"商家优秀推广案例", @"系统消息",@"聊天消息",@"推荐给朋友",@"意见反馈", @"在线客服", @"设置"];
    cell.leftIcon.image = [UIImage imageNamed:imageNames[indexPath.row]];
    cell.titleLabel.text = titleNames[indexPath.row];
    if (indexPath.row == 0) {
        NSAttributedString *attr1 = [[NSAttributedString alloc] initWithString:@"使用说明" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: kCustomColor(102, 102, 102)}];
        NSAttributedString *attr2 = [[NSAttributedString alloc] initWithString:@"  不知道如何使用 进入查看" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: Red_Color}];
        NSMutableAttributedString *mulAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attr1];
        [mulAttr appendAttributedString:attr2];
        cell.titleLabel.attributedText = mulAttr;
        
        if (!self.useExplainFlagView) {
            self.useExplainFlagView = [[UIImageView alloc] init];
        }
        if (IPhone5) {
            [cell addSubview:self.useExplainFlagView];
            [self.useExplainFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(32, 32));
                make.right.equalTo(kSize(-12));
                make.left.equalTo(cell.titleLabel.mas_right).equalTo(4);
                make.centerY.equalTo(0);
            }];
            self.useExplainFlagView.backgroundColor = [UIColor whiteColor];
        } else {
            [cell.contentView addSubview:self.useExplainFlagView];
            [self.useExplainFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(CGSizeMake(32, 32));
                make.left.equalTo(cell.titleLabel.mas_right).equalTo(16);
                make.centerY.equalTo(0);
            }];
        }
        self.useExplainFlagView.image = [UIImage imageNamed:@"useExplain_flag"];
        self.useExplainFlagView.hidden = YES;
        // 使用说明红点提示是否显示
        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
        if (kHasUseExpalinUpdate && !isReade) {
            self.useExplainFlagView.hidden = NO;
        } else {
            self.useExplainFlagView.hidden = YES;
        }
    } else {
        cell.titleLabel.text = titleNames[indexPath.row];
    }
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0 || indexPath.row == 1) {
        
    } else {
        if (_isLogined == NO && (indexPath.row!= 0 || indexPath.row != 1)) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
    }
    
    if (indexPath.row == 0) { // 使用说明
        // 使用说明设置为已读， 隐藏红点
        self.useExplainFlagView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kuseExplainFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];

        ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
        VC.titleStr = @"排名攻略";
        NSString *shareURL = [BASEHTML stringByAppendingString:PaiMingGongLue];
        VC.webUrl = shareURL;//INSTRCTIONHTML;
        VC.isAddBaseUrl = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }
    if (indexPath.row == 1) {
        ExcellentCaseViewController *powerIntroVC = [[ExcellentCaseViewController alloc] init];
        powerIntroVC.controllerType = ExcellentCaseViewControllerTypeExcellentCase;
        [self.navigationController pushViewController:powerIntroVC animated:YES];
    }
    if (indexPath.row == 2) {
        SystemMessageViewController *systemVC = [[SystemMessageViewController alloc]init];
        [self.navigationController pushViewController:systemVC animated:YES];
    }
    if (indexPath.row == 3) {
#if DELETEHUANXIN
        // (@"注释掉环信")
        [[PublicTool defaultTool] publicToolsHUDStr:@"此功能暂缓开通" controller:self sleep:1.0];
#else
        //(@"打开环信代码")
        RemindViewController *remindVC = [[RemindViewController alloc]init];
        [self.navigationController pushViewController:remindVC animated:YES];
#endif
    }
    
    if (indexPath.row == 4) {
        // 推荐给朋友
        [MobClick event:@"TuiJianShare"];
        self.shareView.hidden = NO;
    }
    if (indexPath.row == 5) {
        feedbackVC *settingVC = [[feedbackVC alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    if (indexPath.row == 6) {//在线客服
      /*  ZCHPublicWebViewController *controller = [[ZCHPublicWebViewController alloc]init];
        controller.titleStr = @"在线客服";
        controller.isAddBaseUrl = true;
        controller.webUrl = @"https://www.sobot.com/chat/h5/index.html?sysNum=7d87eb54f5e049be8c6e8d6e5a944826";
        [self.navigationController pushViewController:controller animated:YES];*/
        
        NSString *qqstr = @"3379607351";
        NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqstr];
        NSURL *url = [NSURL URLWithString:qq];
        [[UIApplication sharedApplication] openURL:url];

    }
    if (indexPath.row == 7) {
        SettingViewController *settingVC = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 98, kSCREEN_WIDTH, kSCREEN_HEIGHT - 98) style:(UITableViewStylePlain)];
        if (IphoneX) {
            _tableView.frame = CGRectMake(0, 98 + 22, kSCREEN_WIDTH, kSCREEN_HEIGHT - 98 - 22 - 74);
        } else {
            _tableView.frame = CGRectMake(0, 98, kSCREEN_WIDTH, kSCREEN_HEIGHT - 98 - 44);
        }
        [self.view addSubview:_tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerNib:[UINib nibWithNibName:@"NewMeCell" bundle:nil] forCellReuseIdentifier:@"NewMeCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        UIView *tableHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 125)];
        tableHeaderV.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = tableHeaderV;
        UILabel *nameLabel = [UILabel new];
        [tableHeaderV addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(50);
            make.centerX.equalTo(0);
        }];
        nameLabel.text = @"未登录";
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:17];
        self.personalNameLabel = nameLabel;
        
        self.zhiimg = [[UIImageView alloc] init];
        self.zhiimg.image = [UIImage imageNamed:@"icon_zhixingjingli"];
        [self.view addSubview:self.zhiimg];
        [self.zhiimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameLabel);
            make.width.mas_offset(16);
            make.height.mas_offset(16);
            make.left.equalTo(nameLabel.mas_right).with.offset(6);
        }];
        
        
        UILabel *vipNumLabel = [UILabel new];
        [tableHeaderV addSubview:vipNumLabel];
        [vipNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).equalTo(12);
            make.right.equalTo(-kSCREEN_WIDTH/2.0 - 15);
        }];
        vipNumLabel.textColor = [UIColor lightGrayColor];
        vipNumLabel.font = [UIFont systemFontOfSize:15];
        vipNumLabel.text = [NSString stringWithFormat:@"会员号：%ld", self.userModel.agencyId];
        self.vipNumLabel = vipNumLabel;
        
        UIButton *vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tableHeaderV addSubview:vipBtn];
        [vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(80, 23));
            make.centerY.equalTo(vipNumLabel);
            make.left.equalTo(vipNumLabel.mas_right).equalTo(30);
        }];
        [vipBtn setTitle:@"号码通" forState:UIControlStateNormal];
        [vipBtn setTitle:@"号码通" forState:UIControlStateSelected];
        [vipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [vipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [vipBtn setImage:[UIImage imageNamed:@"note"] forState:UIControlStateNormal];
        [vipBtn setImage:[UIImage imageNamed:@"note1"] forState:UIControlStateSelected];
        vipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.vipBtn = vipBtn;
//        [vipBtn addTarget:self action:@selector(vipBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        UIView *lineView = [[UIView alloc] init];
        [tableHeaderV addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(16);
            make.right.equalTo(-16);
            make.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
        lineView.backgroundColor = kCustomColor(242, 242, 242);
        
    }
    return _tableView;
}

- (ShareView*)shareView {
    
    if (!_shareView) {
        _shareView = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        __weak NewMeViewController *weakSelf = self;
        
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
    [self.tableView reloadData];
    self.vipNumLabel.hidden = !_isLogined;
    self.vipBtn.hidden = !_isLogined;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
