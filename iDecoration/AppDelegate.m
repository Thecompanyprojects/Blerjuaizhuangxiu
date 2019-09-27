//
//  AppDelegate.m
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AppDelegate.h"
#import "SNNavigationController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <JPUSHService.h>
#import <AlipaySDK/AlipaySDK.h>
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "worktypeVC.h"
#import <MagicalRecord/MagicalRecord.h>
// 收到远程通知后点击通知条跳转页
#import "NeedDecorationViewController.h"
#import "CompanyApplyViewController.h"
#import "CalculateViewController.h"
#import <UMMobClick/MobClick.h>
#import "MyCompanyViewController.h"
#import "ZCHCooperateMesController.h"
#import "SiteGroupChatViewController.h"
#import "UnionInviteMessageController.h"
#import "ActivityMessageViewController.h"
#import "ZCHUnionApplyMsgController.h"
#import "MyBeautifulArtController.h"
#import <AFHTTPSessionManager.h>
#import "DMCustomURLSessionProtocol.h"
#import <OpenShare/OpenShareHeader.h>

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) NSMutableDictionary *pushDic;
@property (copy, nonatomic) NSString *url;

// 语音播报
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation AppDelegate

// 1: 客户预约  4: 计算报价(您有一个新的订单)     9: 报名活动(您有一个新的报名)
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSURLProtocol registerClass:[DMCustomURLSessionProtocol class]];
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService resetBadge];
    }
    [UIViewController load];
    [MagicalRecord setupAutoMigratingCoreDataStack];

    self.window = [[UIWindow alloc]initWithFrame:self.window.bounds];
    self.window.backgroundColor = White_Color;
    
    [self setUpUM];
#pragma mark -- 网络请求
    [self netWorkSetting];

#pragma mark -- 键盘监听
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 这里统一设置键盘处理
    manager.toolbarDoneBarButtonItemText = @"完成";
    manager.toolbarTintColor = kMainThemeColor;
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = YES;//这个是它自带键盘工具条开关
    
#pragma mark -- 微信SDK
    [self weChatSDK];
    
#pragma mark -- 环信SDK
    
    [self EMSdkOption];
    
   
#pragma mark -- 极光推送SDK
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc]init];
//        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    }else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //  kJPUSHFlag 值为0 为测试环境  1为开发环境
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:@"App Store"
                 apsForProduction:kJPUSHFlag
            advertisingIdentifier:advertisingId];

  
    // 向服务器注册registrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            NSLog(@"registrationID获取成功：%@",registrationID);
        }else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    

#pragma  mark -- 设置跟控制器
    //    测试使用
    self.appRootTabBarVC = [[SNTabBarController alloc] init];
    self.window.rootViewController = self.appRootTabBarVC;
    [self.window makeKeyAndVisible];
    
    [self somethingForFutureWithType:@"1"];
    
    
    // 只有在前端运行的时候才能收到自定义消息的推送。从jpush服务器获取用户推送的自定义消息内容和标题以及附加字段等。
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    // 如果 App 状态为未运行，此函数将被调用，如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        
    }
    
#pragma  mark - 语音播报
    NSError *error = NULL;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    if(error) {
        // Do some error handling
    }
    [session setActive:YES error:&error];
    
    if (error) {
        // Do some error handling
    }
    // 让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    // 判断用户是够被禁用
    [self checkUserState];

    [self setupShare];

    worktypeVC *controller = [worktypeVC new];
    [controller Network];
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"HomeBroadcastPlaySoundCount"];
    return YES;
}

#pragma mark -- 配置友盟推送
- (void)setUpUM {
    // 设置版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    UMConfigInstance.appKey = kUMKey;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setLogEnabled:YES];
    
    // 账号统计
//    NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
//    if (alias) {
//        [MobClick profileSignInWithPUID:alias];
//    }
    
}

//注册分享码
- (void)setupShare {
    [OpenShare connectQQWithAppId:QQAPPID];
    [OpenShare connectWeixinWithAppId:WeChatAPPID];
}

#pragma mark - 程序在前台收到自定义远程通知后的方法处理
/*
 程序在前台收到自定义远程通知后的方法处理
 content：获取推送的内容
 extras：获取用户自定义参数
 customizeField1：根据自定义key获取自定义的value
 */
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    YSNLog(@"在前端的自定义通知： %@, %@, %@, %@", userInfo, content, extras, customizeField1)
    
}


#pragma mark - 初始化环信
-(void)EMSdkOption{
    
    EMOptions *options = [EMOptions optionsWithAppkey:EMSDKAppKey];
    
    //判断是开发环境还是生产环境
    NSString *certName;
        #ifdef DEBUG
            certName = EMSDKDevCert;
        #else
            certName = EMSDKDisCert;
        #endif
    options.apnsCertName = certName;
    
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    //(@"打开环信代码")
    [[EMClient sharedClient]initializeSDKWithOptions:options];
#endif
    
}




-(void)netWorkSetting{
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = BASEURL;
    config.cdnUrl = @"";
}

-(void)weChatSDK{
    
    [WXApi registerApp:WeChatAPPID];
}


//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)req{
    
}

//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
- (void)onResp:(BaseResp*)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) //判断是否为授权请求，否则与微信支付等功能发生冲突
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0 && [aresp.state isEqualToString:@"1245"])
        {
            NSString *arespCode = aresp.code;
            NSLog(@"code %@",arespCode);
            [self getWeiXinOpenId:arespCode];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"wechatDidLoginNotification" object:self userInfo:@{@"code":aresp.code}];
        }
        if (aresp.errCode== 0 && [aresp.state isEqualToString:@"12456"])
        {
            NSString *arespCode = aresp.code;
            NSLog(@"code %@",arespCode);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bangdingeweixin" object:self userInfo:@{@"code":aresp.code}];
        }
        
    }
    //qq反馈判断
    if ([resp isKindOfClass:[QQBaseResp class]]) {
        
    }
    else
    {
        //启动微信支付的response
        NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        if([resp isKindOfClass:[PayResp class]]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPayResult" object:@(resp.errCode)];
            //支付返回结果，实际支付结果需要去微信服务器端查询
            switch (resp.errCode) {
                case 0:
                    payResoult = @"支付结果：成功！";
                    break;
                case -1:
                    payResoult = @"支付结果：失败！";
                    break;
                case -2:
                    payResoult = @"用户已经退出支付！";
                    break;
                default:
                    payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                    break;
            }
        }
    }
    
    

}

- (void)WXPayWithDic:(NSDictionary *)dic {
    
    PayReq *request = [[PayReq alloc] init] ;
    request.partnerId = dic[@"partnerid"];
    request.prepayId= dic[@"prepayid"];
    request.package = dic[@"package"];
    request.nonceStr= dic[@"noncestr"];
    request.timeStamp= [dic[@"timestamp"] intValue];
    request.sign= dic[@"sign"];
    [WXApi sendReq:request];
}

//通过code获取access_token，openid，unionid

- (void)getWeiXinOpenId:(NSString *)code{
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAPPID,WeChatAPPSECRET,code];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *access_token = [dic objectForKey:@"access_token"];//接口调用凭证
        NSString *refresh_token = [dic objectForKey:@"refresh_token"];//用于刷新access_token
        NSString *openID = [dic objectForKey:@"openid"];//用户唯一授权标识
//        NSString *unionid = [dic objectForKey:@"unionid"];//当且仅当该移动应用已获得用户userinfo授权时,才会出现该字段
//        NSString *scope = [dic objectForKey:@"scope"];//用户授权的作用域，使用（，）逗号分隔
//        NSString *expires_in = [dic objectForKey:@"expires_in"];//接口调用凭证超时时间（秒）
        // 获取微信信息
//        [self access_token:access_token openid:openID];
        
      
        
        [self refreshAccessTokenByOpenID:openID grant_type:refresh_token refreshToken:access_token];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 通过微信access_token获取个人信息
- (void)access_token:(NSString *)access_token openid:(NSString *)openid
{
    NSDictionary *parameter = @{@"access_token":access_token,@"openid":openid};
    [NetManager afPostRequest:@"https://api.weixin.qq.com/sns/userinfo?" parms:parameter finished:^(id responseObj) {
        
    } failed:^(NSString *errorMsg) {
        
    }];

}

#pragma mark - 发送到自己的服务器绑定微信
- (void)bindWXWithOpenID:(NSString *)openID {
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *agencyIdStr = [NSString stringWithFormat:@"%ld", agencyid];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:agencyIdStr forKeyedSubscript:@"agencyId"];
    [paramDic setObject:openID forKeyedSubscript:@"wxCode"];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/bandWx.do"];
    
    YSNLog(@"%@", paramDic);
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] isEqualToString:@"1000"]) {
            // 绑定成功
            YSNLog(@"ddddd'");
            //            成功回调后通知个人中心的设置，已经绑定微信。
            [[NSNotificationCenter defaultCenter] postNotificationName:kWeiXinBindSuccess object:nil];
        }
        
        if ([[responseObj objectForKey:@"code"] isEqualToString:@"1002"]) {
            YSNLog(@"已绑定其他账号");
//            [[PublicTool defaultTool] publicToolsHUDStr:@"已绑定其他账号" controller:[self getCurrentVC] sleep:1.0];
        }
        if ([[responseObj objectForKey:@"code"] isEqualToString:@"2000"]) {
            YSNLog(@"失败");
//            [[PublicTool defaultTool] publicToolsHUDStr:@"绑定失败" controller:[self getCurrentVC] sleep:1.0];
        }
    } failed:^(NSString *errorMsg) {
       [[PublicTool defaultTool] publicToolsHUDStr:NETERROR controller:[self getCurrentVC] sleep:1.0];
    }];
    

}


#pragma mark -- 刷新微信登录access_token有效期

-(void)refreshAccessTokenByOpenID:(NSString*)openID grant_type:(NSString*)grant_type refreshToken:(NSString*)refresh_token{
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=%@&refresh_token=%@",WeChatAPPID,grant_type,refresh_token];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    if ([url.scheme isEqualToString:WeChatAPPID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAPPID]]) {
        return [TencentOAuth HandleOpenURL:url];
    }

    return YES;

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }

    if ([url.scheme isEqualToString:@"openazx"]) {
        NSString *urlString = [url absoluteString];
        // openazx://?type=1
        NSDictionary *paramDic = [self getParamsWithUrlString:urlString][1];
        
        SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
        SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
        BOOL isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
        if (!isLogined) {
            // 未登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.tag = 300;
            [self.appRootTabBarVC.selectedViewController pushViewController:loginVC animated:YES];
            return YES;
        }
        
        if ([[paramDic objectForKey:@"type"] isEqualToString:@"1"]) {
            MyBeautifulArtController *siteVC = [[MyBeautifulArtController alloc]init];
            if ([naviVC.viewControllers.lastObject class]!= [MyBeautifulArtController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:siteVC animated:YES];
            }
        }
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayResult" object:resultDic];
        }];
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AlipayResult" object:resultDic];
        }];
        return YES;
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AlipayResult" object:resultDic];
        }];
    }
    
    if ([url.scheme isEqualToString:WeChatAPPID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAPPID]]) {
        return [TencentOAuth HandleOpenURL:url];
    }else {

        return YES;
    }
    return YES;
}



// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.scheme isEqualToString:@"openazx"]) {
        NSString *urlString = [url absoluteString];
        // openazx://?type=1
        NSDictionary *paramDic = [self getParamsWithUrlString:urlString][1];
        
        SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
        SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
        BOOL isLogined = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
        if (!isLogined) {
            // 未登录
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.tag = 300;
            [self.appRootTabBarVC.selectedViewController pushViewController:loginVC animated:YES];
            return YES;
        }
        
        if ([[paramDic objectForKey:@"type"] isEqualToString:@"1"]) {
            MyBeautifulArtController *siteVC = [[MyBeautifulArtController alloc]init];
            if ([naviVC.viewControllers.lastObject class]!= [MyBeautifulArtController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:siteVC animated:YES];
            }
        }
        return YES;
    }
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayResult" object:resultDic];
        }];
        [[AlipaySDK defaultService]processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AlipayResult" object:resultDic];
        }];
        return YES;
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AlipayResult" object:resultDic];
        }];
    }
    
    
    if ([url.scheme isEqualToString:WeChatAPPID]) {
        return [WXApi handleOpenURL:url delegate:self];
    }else if ([url.scheme isEqualToString:[NSString stringWithFormat:@"tencent%@",QQAPPID]]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return [TencentOAuth HandleOpenURL:url];
    }else {

        return YES;
    }

    return YES;
}



#pragma mark - 支付宝支付
- (void)ALiPayWithDic:(NSDictionary *)dic {
    
    [[AlipaySDK defaultService] payOrder:dic[@"orderStr"] fromScheme:ALiPayAppid callback:^(NSDictionary *resultDic) {
        
        NSLog(@"%@", resultDic);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayResult" object:resultDic];
    }];
    
    
}


#pragma mark - 微信支付
//============================================================
// 微信支付流程实现
//============================================================

//- (void)sendPay_demo:(NSString *)orderNum andName:(NSString *)name andPrice:(NSString *)price andExtend:(NSString *)callBackUrl
//{
//    //创建支付签名对象
//    payRequsestHandler *req = [payRequsestHandler alloc];
//    //初始化支付签名对象
//    [req init:APP_ID mch_id:MCH_ID];
//    //设置密钥
//    [req setKey:PARTNER_ID];
//    
//    //}}}
//    
//    //获取到实际调起微信支付的参数后，在app端调起支付
//    NSMutableDictionary *dict = [req sendPay_demo:orderNum andName:name andPrice:price andExtend:callBackUrl];
//    
//    if(dict == nil)
//    {
//        //错误提示
//        NSString *debug = [req getDebugifo];
//        
//        //        [self alert:@"提示信息" msg:debug];
//        
//        NSLog(@"%@\n\n",debug);
//    }
//    else
//    {
//        NSLog(@"%@\n\n",[req getDebugifo]);
//        //                [self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
//        
//        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//        NSMutableString *retcode = [dict objectForKey:@"retcode"];
//        
//        if (retcode.intValue == 0)
//        {
//            
//            //调起微信支付
//            PayReq* req             = [[PayReq alloc] init];
//            req.openID              = [dict objectForKey:@"appid"];
//            req.partnerId           = [dict objectForKey:@"partnerid"];
//            req.prepayId            = [dict objectForKey:@"prepayid"];
//            req.nonceStr            = [dict objectForKey:@"noncestr"];
//            req.timeStamp           = stamp.intValue;
//            req.package             = [dict objectForKey:@"package"];
//            req.sign                = [dict objectForKey:@"sign"];
//            [WXApi sendReq:req];
//        }
//        else
//        {
//            [self alert:@"提示信息" msg:[dict objectForKey:@"retmsg"]];
//        }
//        
//    }
//}
//
////客户端提示信息
//- (void)alert:(NSString *)title msg:(NSString *)msg
//{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    [alter show];
//}
//
//-(void) onResp:(BaseResp*)resp
//{
//    
//    if([resp isKindOfClass:[PayResp class]]){
//        //支付返回结果，实际支付结果需要去微信服务器端查询
//        
//        switch (resp.errCode) {
//            case WXSuccess:
//            {
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaySuccessNotification" object:self userInfo:nil];
//            }
//                break;
//            case WXErrCodeUserCancel:
//            {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayCancleNotification" object:self userInfo:nil];
//            }
//                break;
//                
//            default:
//                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                [self alert:@"" msg:[NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr]];
//                break;
//        }
//    }
//}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSInteger code = [userInfo[@"messageType"] integerValue];
    if (code == 12) {
        [self clearInfoAndlogout];
    }
    
    
    // 判断是否是远程推送远程推送
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        // 在前台收到远程推送,自动调用
        // doSomething。。。。
        [[NSNotificationCenter defaultCenter] postNotificationName:kReciveRemoteNotification object:nil userInfo:userInfo];
        if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [JPUSHService resetBadge];
        }
        
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert| UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
//    // 4计算报价: calculatorReport 1客户预约: appointmentReport 9报名活动: activityReport
//    if ([[userInfo objectForKey:@"messageType"] integerValue] == 1 || [[userInfo objectForKey:@"messageType"] integerValue] == 4) {
//
//        if ([[userInfo objectForKey:@"messageType"] integerValue] == 4) {// 计算报价
//            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"]) {
//
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"] boolValue]) {
//                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
//                    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//                    [synth speakUtterance:utterance];
//                }
//            } else {
//
//                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
//                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//                [synth speakUtterance:utterance];
//            }
//        } else {// 客户预约
//
//            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"]) {
//
//                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"] boolValue]) {
//                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
//                    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//                    [synth speakUtterance:utterance];
//                }
//            } else {
//
//                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
//                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//                [synth speakUtterance:utterance];
//            }
//        }
//    }
//
//    if ([[userInfo objectForKey:@"messageType"] integerValue] == 9) {
//
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"]) {
//
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"] boolValue]) {
//                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的报名"];
//                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//                [synth speakUtterance:utterance];
//            }
//        } else {
//
//            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的报名"];
//            AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
//            [synth speakUtterance:utterance];
//        }
//    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    self.pushDic = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
    
    if (self.pushDic) {
        NSUserDefaults *pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@"push" forKey:@"push"];
        [pushJudge synchronize];
    }
    
    // 后台挂起 点击icon后没有接受消息的方法， 后台挂起， 接受通知消息方法没有
    // 在前台点击推动的通知，  后台挂起点击推送的通知 走该方法
    // 判断是否是远程通知
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        // doSomething....
        if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [JPUSHService resetBadge];
        }
        
        // 测试收到远程推动后的跳转
        [self reciveRemotePushMessage:userInfo];
        [JPUSHService resetBadge];
    } else {
        // 本地通知
        
#if DELETEHUANXIN
        // (@"注释掉环信")
#else
        // (@"打开环信代码")
        NSString *str = [self.pushDic objectForKey:kHXLocalNotificationIdentify];
        if (str != nil && str.length > 0) {
            // 点击环信本地通知 跳转到聊天界面
            NSString *conversationId = [self.pushDic objectForKey:@"ConversationChatter"];
            EMConversationType messageType = (EMConversationType)[[self.pushDic objectForKey:@"MessageType"] integerValue];
            NSString *title = @"";
            
            SiteGroupChatViewController *groupChatVC = [[SiteGroupChatViewController alloc]initWithConversationChatter:conversationId conversationType:messageType];
            
            if (messageType == EMConversationTypeChat) {
                // 单聊
            } else if(messageType == EMConversationTypeGroupChat) {
                // 群聊
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:conversationId error:nil];
                title = group.subject;
            }
            groupChatVC.chatTitle = title;
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [CompanyApplyViewController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:groupChatVC animated:YES];
            }
            
        }
#endif
    }
    completionHandler();  // 系统要求执行这个方法
}

// 如果 App状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。此种情况在此函数中处理：
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // 4计算报价: calculatorReport 1客户预约: appointmentReport 9报名活动: activityReport
    if ([[userInfo objectForKey:@"messageType"] integerValue] == 1 || [[userInfo objectForKey:@"messageType"] integerValue] == 4) {
        
        if ([[userInfo objectForKey:@"messageType"] integerValue] == 4) {// 计算报价
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"]) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"] boolValue]) {
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                    [synth speakUtterance:utterance];
                }
            } else {
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
        } else {// 客户预约
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"]) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"] boolValue]) {
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                    [synth speakUtterance:utterance];
                }
            } else {
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
        }
    }
    
    if ([[userInfo objectForKey:@"messageType"] integerValue] == 9) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"]) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"] boolValue]) {
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的报名"];
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
        } else {
            
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的报名"];
            AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
            [synth speakUtterance:utterance];
        }
    }
    
    // Required, iOS 7 Support
    [[NSNotificationCenter defaultCenter] postNotificationName:kReciveRemoteNotification object:nil userInfo:userInfo];
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService resetBadge];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kReciveRemoteNotification object:nil userInfo:userInfo];
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService resetBadge];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    
    // 4计算报价: calculatorReport 1客户预约: appointmentReport 9报名活动: activityReport
    if ([[userInfo objectForKey:@"messageType"] integerValue] == 1 || [[userInfo objectForKey:@"messageType"] integerValue] == 4) {
        
        if ([[userInfo objectForKey:@"messageType"] integerValue] == 4) {// 计算报价
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"]) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"calculatorReport"] boolValue]) {
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                    [synth speakUtterance:utterance];
                }
            } else {
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
        } else {// 客户预约
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"]) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"appointmentReport"] boolValue]) {
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                    [synth speakUtterance:utterance];
                }
            } else {
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的订单"];
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
        }
    }
    
    if ([[userInfo objectForKey:@"messageType"] integerValue] == 9) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"]) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"activityReport"] boolValue]) {
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的报名"];
                AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
                [synth speakUtterance:utterance];
            }
        } else {
            
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"您有一个新的报名"];
            AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
            [synth speakUtterance:utterance];
        }
    }
}


#pragma mark - JPUSH 注册

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // JPUSH登录成功后 alias 为用户设置别名（一个用户仅有一个，该别名为agencyId）  tags 为用户标签（可以设置多个，此处设置为空）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceTokenData"];
}
/**
 *  登录成功，设置别名，移除监听
 */
- (void)networkDidLogin:(NSNotification *)notification {
    NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    [JPUSHService setTags:nil aliasInbackground:alias];
    NSInteger aliasInt = alias.integerValue;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (alias == 0) {
            [JPUSHService setTags:nil alias:@"logout" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
             {
                 YSNLog(@"iResCode: %d, alias: %@", iResCode, iAlias);
             }];
        } else {
            [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%ld", (long)aliasInt] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
             {
                 YSNLog(@"iResCode: %d, alias: %@", iResCode, iAlias);
             }];
        }
        
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


#pragma mark - 接收到远程通知跳转到指定页面
- (void)reciveRemotePushMessage:(NSDictionary *)userInfo {
    
    NSInteger code = [userInfo[@"messageType"] integerValue];
    switch (code) {
        case 1:
        {
            // 跳转到喊装修列表
            NeedDecorationViewController *needVC = [[NeedDecorationViewController alloc] init];
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [NeedDecorationViewController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:needVC animated:YES];
            }
            
        }
            break;
        case 2:
        {
            // 跳转到公司申请列表
            CompanyApplyViewController *comVC = [[CompanyApplyViewController alloc] init];
            
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [CompanyApplyViewController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:comVC animated:YES];
            }

            
        }
            break;
        case 3:
        {
            // 跳转到我的公司页面
            MyCompanyViewController *companyVC = [[MyCompanyViewController alloc]init];
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            
            
            if ([naviVC.viewControllers.lastObject class]!= [MyCompanyViewController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:companyVC animated:YES];
            }
            
        }
            break;
        case 4:
        {
            // 跳转到计算器列表
            CalculateViewController *calcuVC = [[CalculateViewController alloc] init];

            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];

            if ([naviVC.viewControllers.lastObject class]!= [CalculateViewController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:calcuVC animated:YES];
            }
            
        }
            break;
        case 5:
        {
            // 跳转到合作企业
            ZCHCooperateMesController *cooperateMesVC = [[ZCHCooperateMesController alloc] init];
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [ZCHCooperateMesController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:cooperateMesVC animated:YES];
            }
        }
            break;
        case 7:
        {
            // 申请加入联盟
            ZCHUnionApplyMsgController *applyVC = [[ZCHUnionApplyMsgController alloc] init];
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [ZCHUnionApplyMsgController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:applyVC animated:YES];
            }
        }
            break;
       
        case 9:
        {
            // 跳转报名活动消息
            ActivityMessageViewController *cooperateMesVC = [[ActivityMessageViewController alloc] init];
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [ActivityMessageViewController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:cooperateMesVC animated:YES];
            }
        }
            break;
        case 10:
        {
            // 联盟邀请
            UnionInviteMessageController *cooperateMesVC = [[UnionInviteMessageController alloc] init];
            SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
            SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
            if ([naviVC.viewControllers.lastObject class]!= [UnionInviteMessageController class]) {
                [self.appRootTabBarVC.selectedViewController pushViewController:cooperateMesVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
    
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // 开启后台处理多媒体事件(语音播报)
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    
    // 后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    _backgroundTaskIdentifier = [AppDelegate backgroundPlayerID:_backgroundTaskIdentifier];
    // 其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
}

//实现一下backgroundPlayerID:这个方法:
+ (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId {// 语音播报
    
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid){
        
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    
    return newTaskId;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [MagicalRecord cleanUp];
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    //(@"打开环信代码")
    [[EMClient sharedClient] applicationDidEnterBackground:application];
#endif
    
    
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        // 消息数量添加 使用说明提示
        BOOL isReade = [[NSUserDefaults standardUserDefaults] boolForKey:kuseExplainFlag];
        if (kHasUseExpalinUpdate && !isReade) {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
        } else {
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [JPUSHService resetBadge];
        }
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

    [self checkUserState];
    
    [JPUSHService resetBadge];
#if DELETEHUANXIN
    // (@"注释掉环信")
#else
    //(@"打开环信代码")
    [[EMClient sharedClient] applicationWillEnterForeground:application];
#endif
    
    
    if (![[PublicTool defaultTool] publicToolsJudgeIsLogined]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService resetBadge];
    }
    [self somethingForFutureWithType:@"2"];
    
    
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [JPUSHService resetBadge];
//    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}


#pragma mark - 强制退出登录
- (void)checkUserState {
    BOOL isLogin = [[PublicTool defaultTool] publicToolsJudgeIsLogined];
    if (isLogin) {
        UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
        NSString *defaultUrl = [BASEURL stringByAppendingString:[NSString stringWithFormat:@"agency/logoutState/%ld.do", model.agencyId]];
        [NetManager afPostRequest:defaultUrl parms:nil finished:^(id responseObj) {
            
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            if (code == 1000) {
                NSInteger state = [[responseObj objectForKey:@"data"][@"state"] integerValue];
                // 状态值0:禁用，1：启用
                if (state == 0) {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"您已被禁号，请联系管理人员" preferredStyle:(UIAlertControllerStyleAlert)];
                    MJWeakSelf;
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf clearInfoAndlogout];
                    }];
                    [alertC addAction:action];
                    [self.window.rootViewController presentViewController:alertC animated:YES completion:nil];
                    
                }
            }
        } failed:^(NSString *errorMsg) {
            
        }];
    }
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
    
    SNTabBarController *tabBarVC = (SNTabBarController *)self.window.rootViewController;
    SNNavigationController *naviVC = tabBarVC.viewControllers[tabBarVC.selectedIndex];
    if ([naviVC.viewControllers.lastObject class]!= [ZCHCooperateMesController class]) {
        [self.appRootTabBarVC.selectedViewController pushViewController:loginVC animated:YES];
    }
}

#pragma mark - 这个为以后做准备
- (void)somethingForFutureWithType:(NSString *)type {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *api = [BASEURL stringByAppendingString:@"user/getVersion.do"];
    NSDictionary *param = @{
                            @"verision" : version,
                            @"random" : @"7777777"
                            };
    
    [NetManager afGetRequest:api parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            NSDictionary *dic = responseObj[@"data"];
             // 可选更新
            if ([dic[@"type"] integerValue] == -1 && [type isEqualToString:@"1"]) {
                
                self.url = dic[@"url"];
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"提示" message:dic[@"msg"] clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    
                    __weak typeof(self) weakSelf = self;
                    if (buttonIndex == 1) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.url]];
                        });
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                [alertView show];
            }
            
            // 强制更新
            if ([dic[@"type"] integerValue] == 1 && ([type isEqualToString:@"1"] || [type isEqualToString:@"2"])) {
                
                self.url = dic[@"url"];
                __weak typeof(self) weakSelf = self;
                TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"提示" message:dic[@"msg"] clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.url]];
                    });
                } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                
                [alertView show];
            }
            
        }
    } failed:^(NSString *errorMsg) {
        
    }];
    
}

/**
 获取url中的参数并返回
 @param urlString 带参数的url
 @return @[NSString:无参数url, NSDictionary:参数字典]
 */

- (NSArray*)getParamsWithUrlString:(NSString*)urlString {
    if(urlString.length==0) {
        NSLog(@"链接为空！");
        return @[@"",@{}];
    }
    //先截取问号
    NSArray*allElements = [urlString componentsSeparatedByString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//待set的参数字典
    if(allElements.count==2) {
        //有参数或者?后面为空
        NSString*myUrlString = allElements[0];
        NSString*paramsString = allElements[1];
        //获取参数对
        NSArray*paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count>=2) {
            for(NSInteger i =0; i < paramsArray.count; i++) {
                NSString*singleParamString = paramsArray[i];
                NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count==2) {
                    NSString*key = singleParamSet[0];
                    NSString*value = singleParamSet[1];
                    if(key.length>0|| value.length>0) {
                        [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                    }
                }
            }
        }else if(paramsArray.count==1) {
            //无 &。url只有?后一个参数
            NSString*singleParamString = paramsArray[0];
            NSArray*singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count==2) {
                NSString*key = singleParamSet[0];
                NSString*value = singleParamSet[1];
                if(key.length>0|| value.length>0) {
                    [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                }
            }else{
                //问号后面啥也没有 xxxx?  无需处理
            }
        }
        //整合url及参数
        return@[myUrlString,params];
    }else if(allElements.count>2) {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        return @[@"",@{}];
    }else{
        NSLog(@"链接不包含参数！");
        return@[urlString,@{}];
    }
 
}


@end
