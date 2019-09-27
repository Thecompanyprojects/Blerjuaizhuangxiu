//
//  SNTabBarController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNTabBarController.h"
#import "SNNavigationController.h"
#import "HomeViewController.h"
#import "LocalViewController.h"
#import "localVC.h"
#import "NewManagerViewController.h"
#import "NewMeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import <JPUSHService.h>
#import <UserNotifications/UserNotifications.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SNTabBarController ()<EMClientDelegate, UITabBarControllerDelegate, EMChatManagerDelegate>
@property (nonatomic, assign) NSInteger messageTotalNum;
@end

@implementation SNTabBarController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    //(@"打开环信代码")
    // 设置环信代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
#endif
    
    
    // 注册本地通知
    UIApplication *application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    // (@"打开环信代码")
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
#endif
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setUpAllChildViewController];
    self.delegate = self;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:[SNNavigationController class]]) {
        SNNavigationController *nav = (SNNavigationController *)viewController;
        if (nav.viewControllers.count > 1) {
            [nav popToRootViewControllerAnimated:NO];
        }
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  添加所有子控制器
 */
- (void)setUpAllChildViewController{
    //判断是不是第一次登陆
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
    
    //改变tabbar字体颜色
    self.tabBar.tintColor = Main_Color;
    
    //首页
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    SNNavigationController *homeNav = [[SNNavigationController alloc]initWithRootViewController:homeVC];
    homeVC.tabBarItem.image = [UIImage imageNamed:@"huangyeUnselected"];
    homeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"huangyeSelected"];
    homeNav.navigationController.navigationBar.tintColor = White_Color;
    homeVC.title = @"企业";
    
    //同城
    localVC *local = [[localVC alloc] init];
    SNNavigationController *localNav = [[SNNavigationController alloc]initWithRootViewController:local];
    local.tabBarItem.image = [UIImage imageNamed:@"tongcheng"];
    local.tabBarItem.selectedImage = [UIImage imageNamed:@"tongchengd"];
    localNav.navigationController.navigationBar.tintColor = White_Color;
    local.title = @"同城";
    
    //工地管理
    NewManagerViewController *NewManagerVC = [[NewManagerViewController alloc]init];
    SNNavigationController *NewManagerNav = [[SNNavigationController alloc]initWithRootViewController:NewManagerVC];
    
    
    NewManagerVC.tabBarItem.image = [UIImage imageNamed:@"icon_yunguanli"];
    NewManagerVC.tabBarItem.selectedImage = [UIImage imageNamed:@"icon_yunguanli_pre"];
    NewManagerNav.navigationController.navigationBar.tintColor = White_Color;
    NewManagerVC.title = @"云管理";
    
    
    //我
//    MeViewController *meVC = [[MeViewController alloc]init];
    NewMeViewController *meVC = [NewMeViewController new];
    SNNavigationController *meNav = [[SNNavigationController alloc]initWithRootViewController:meVC];
    meVC.tabBarItem.image = [UIImage imageNamed:@"me"];
    meVC.tabBarItem.selectedImage = [UIImage imageNamed:@"mes"];
    meNav.navigationController.navigationBar.tintColor = White_Color;
    meVC.title = @"个人中心";

    
    
    self.viewControllers = @[homeNav,localNav,NewManagerNav,meNav];
     //self.viewControllers = @[localNav,homeNav,NewManagerNav,meNav];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}



#pragma mark - EMClientDelegate
// 环信  当前登录账号在其它设备登录时会接收到该回调
-(void)userAccountDidLoginFromOtherDevice{
    
    [self alertTipsOfChat];
}


/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer {
    [[UIApplication sharedApplication].keyWindow hudShowWithText:@"账户已从服务器端删除"];
}

/*!
 *  自动登录返回结果
 *
 *  @param error 错误信息
 */
- (void)autoLoginDidCompleteWithError:(EMError *)error{
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    //(@"打开环信代码")
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
#endif
    
    
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调  当掉线时，iOS SDK 会自动重连，只需要监听重连相关的回调，无需进行任何操作。
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    YSNLog(@"环信状态 ------- %u  ------%@", aConnectionState,  aConnectionState == 0? @"已连接" : @"未连接" );
}


// 重复登录
-(void)alertTipsOfChat{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你的账号在另一个手机登录，如非本人操作，则密码可能泄露，建议修改密码" preferredStyle:UIAlertControllerStyleAlert];
    
    //退出登录
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //调用退出登录的接口
        //信息清除和跳转登录界面
        
        [self clearInfoAndlogout];
        
    }];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#if DELETEHUANXIN
        // (@"注释掉环信")
#else
        //(@"打开环信代码")
        //退出
        [[EMClient sharedClient] logout:YES];
#endif
        
        
        //重新登录
        UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        
        [self userInfoLogin:model];
        
        
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    
    [self  presentViewController:alert animated:YES completion:nil];
    
}
// 退出登录
-(void)clearInfoAndlogout{
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    //(@"打开环信代码")
    //环信退出登录
    [[EMClient sharedClient] logout:YES];
    YSNLog(@"%@", [EMClient sharedClient].isLoggedIn ? @"登录状态" : @"退出状态");
#endif
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AGENCYDICT];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alias"];
    // 友盟统计停止统计账号
    //        [MobClick profileSignOff];
    //            极光推送退出账号
    
    [JPUSHService setTags:nil alias:@"logout" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
     {
         YSNLog(@"iResCode: %d, alias: %@", iResCode, iAlias);
     }];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserState" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshManageVCData" object:nil];
    // 发送通知，清空消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:klognOutNotification object:nil];
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.tag = 300;
    SNNavigationController  *nav = self.selectedViewController;
    
    [nav  pushViewController:loginVC animated:YES];
}

// 重新登录
-(void)userInfoLogin:(UserInfoModel *)model{

    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/login.do"];
    NSString *psw = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    NSDictionary *paramDic = @{@"phone":model.phone,
                               @"flag":@"1",
                               @"password":psw
                               };

    __weak  typeof(self )  weakSelf = self;
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        YSNLog(@"%@",responseObj);
        
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            switch (code) {
                case 1000:
                {

#if DELETEHUANXIN
                    // (@"注释掉环信")
#else
                    //(@"打开环信代码")
                    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                    if (!isLoggedIn) {
                        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                        if (!EMerror) {
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                        }
                    }
#endif
                    
                }
                    break;
                    
                case 1001:
                {
                    
                    [weakSelf alertTips:@"密码错误"];
                
                }
                    break;
                    
                case 2000:
                {
                    [weakSelf alertTips:@"登录失败!"];
               
                }
                    break;
                    
                case 1004:
                {
                    
                    [weakSelf alertTips:@"该手机号未注册!"];
               
                }
                    break;
                    
                default:
                    break;
            }
        }
        
       
    } failed:^(NSString *errorMsg) {
       
        [self.view hudShowWithText:@"登录失败，请稍后重试"];
    }];

}

-(void)alertTips:(NSString *)str{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self clearInfoAndlogout];
    }];

    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - EMChatManagerDelegate

//收到消息
- (void)messagesDidReceive:(NSArray *)aMessages {
    //判断是不是后台，如果是后台就发推送
    if (aMessages.count==0) {
        return ;
    }
    
    // 发送通知更新消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:kHXUpdateMessageNumberWhenRevievedMessage object:nil];
    
    YSNLog(@"%ld", aMessages.count);
    for (EMMessage*message in aMessages) {
        YSNLog(@"%@", message);
        UIApplicationState state =[[UIApplication sharedApplication] applicationState];
        switch (state) {
                //前台运行
            case UIApplicationStateActive:
            {   
                // 播放震动和声音
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                AudioServicesPlaySystemSound((UInt32)1007);
            }
                break;
                //待激活状态
            case UIApplicationStateInactive:
                break;
                //后台状态
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }

    }

}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    static NSString *kMessageType = @"MessageType";
    static NSString *kConversationChatter = @"ConversationChatter";

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    [userInfo setObject:message.from forKey:@"from"];
    [userInfo setObject:@"kHXLocalNotificationIdentify" forKey:kHXLocalNotificationIdentify];
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.sound = [UNNotificationSound defaultSound];
        content.body = @"您有一条新消息";

        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = @"您收到一条新消息";
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.userInfo = userInfo;

        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    
    
}

@end
