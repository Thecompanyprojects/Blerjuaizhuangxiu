//
//  LoginViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "SNTabBarController.h"
#import "SNNavigationController.h"
#import "LoginApi.h"
#import "WXApi.h"
#import <JPUSHService.h>
#import "AppDelegate.h"
#import "NewMeViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "bindingphoneVC.h"
#import "RegisterselectVC.h"

#import "VIPExperienceShowViewController.h"

@interface LoginViewController ()<JPUSHRegisterDelegate,TencentSessionDelegate>
{
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
}
@property (strong, nonatomic) UIButton *WeChatBtn;
@property (strong, nonatomic) UIButton *QQBtn;
//@property (strong, nonatomic) UIImageView *lineimg;
@property (strong, nonatomic) UILabel *textLab;
@property (strong, nonatomic) UIView *line0;
@property (strong, nonatomic) UIView *line1;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"wechatDidLoginNotification" object:nil];
    [self createUI];
    [self isshowdenglu];
}

-(void)createUI{
    self.view.backgroundColor = Main_Color;
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *userLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    userLeftView.backgroundColor = Clear_Color;
    
    UIImageView *userImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"account"]];
    userImage.frame = CGRectMake(10, 7.5, 20, 25);
    [userLeftView addSubview:userImage];
    
    self.AccountTF.leftView = userLeftView;
    self.AccountTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *pwdLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    pwdLeftView.backgroundColor = Clear_Color;
    
    UIImageView *pwdImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"password"]];
    pwdImage.frame = CGRectMake(10, 7.5, 20, 25);
    [pwdLeftView addSubview:pwdImage];
    
    self.PasswordTF.leftView = pwdLeftView;
    self.PasswordTF.leftViewMode = UITextFieldViewModeAlways;
    
    self.AccountTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    self.PasswordTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];

    self.textLab = [[UILabel alloc] init];
    self.textLab.textAlignment = NSTextAlignmentCenter;
    self.textLab.text = @"第三方登录";
    self.textLab.textColor = [UIColor hexStringToColor:@"D0F4DE"];
    self.textLab.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.textLab];
    
    self.line0 = [[UIView alloc] init];
    self.line0.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    [self.view addSubview:self.line0];
    
    
    self.line1 = [[UIView alloc] init];
    self.line1.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    [self.view addSubview:self.line1];

    self.WeChatBtn = [[UIButton alloc] init];
    [self.WeChatBtn setImage:[UIImage imageNamed:@"weixin-2"] forState:normal];
    [self.WeChatBtn addTarget:self action:@selector(wechatClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.WeChatBtn];
    
    self.QQBtn = [[UIButton alloc] init];
    [self.QQBtn setImage:[UIImage imageNamed:@"qq-1"] forState:normal];
    [self.QQBtn addTarget:self action:@selector(qqclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.QQBtn];
    
    [self setlayout];
}

-(void)setlayout
{
    [self.QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(45);
        make.height.mas_offset(45);
        make.left.equalTo(self.view).with.offset(114);
        make.bottom.equalTo(self.view).with.offset(-65);
    }];
    [self.WeChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(45);
        make.height.mas_offset(45);
        make.right.equalTo(self.view).with.offset(-114);
        make.bottom.equalTo(self.view).with.offset(-65);
    }];
    [self.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_offset(18);
        make.bottom.equalTo(self.view).with.offset(-120);
        make.width.mas_offset(90);
    }];
    [self.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textLab.mas_left).with.offset(2);
        make.width.mas_offset(78*widthScale);
        make.centerY.equalTo(self.textLab);
        make.height.mas_offset(1);
    }];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLab.mas_right).with.offset(2);
        make.width.mas_offset(78*widthScale);
        make.centerY.equalTo(self.textLab);
        make.height.mas_offset(1);
    }];

}

-(void)isshowdenglu
{
     if ([WXApi isWXAppInstalled])
     {
         [self.WeChatBtn setHidden:NO];
     }
     else{
         [self.WeChatBtn setHidden:YES];
     }
    if ([QQApiInterface isQQInstalled]) {
        [self.QQBtn setHidden:NO];
    }
    else
    {
        [self.QQBtn setHidden:YES];
    }
}

// 登录成功后设置别名

- (void)setJPUSHAlias {
//    //            重新注册极光的deviceToken
                        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceTokenData"];
                        [JPUSHService registerDeviceToken:data];
    YSNLog(@"%@", data);
    
    NSString *alias = [[NSUserDefaults standardUserDefaults] objectForKey:@"alias"];
    [JPUSHService setTags:nil aliasInbackground:alias];
    NSInteger aliasInt = alias.integerValue;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%ld", (long)aliasInt] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
         {
             YSNLog(@"iResCode: %d, alias: %@", iResCode, iAlias);
         }];
    });
}


#pragma mark -- 登录
- (IBAction)loginClick:(id)sender {
    
    if (self.AccountTF.text.length == 0 || self.PasswordTF.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入用户名或密码" controller:self sleep:1.0];
        
        return;
    }
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/login.do"];
    NSDictionary *paramDic = @{@"phone":self.AccountTF.text,
                               @"flag":@"1",
                               @"password":self.PasswordTF.text
                               };
    [self.view hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        YSNLog(@"%@",responseObj);
        if (responseObj && (NSInteger)responseObj[@"code"] != 10004) {
            
            NSDictionary *dict = [responseObj objectForKey:@"agency"];
            NSString *impl = [dict objectForKey:@"impl"];//是否是执行经理  0 不是 1 是
            [[NSUserDefaults standardUserDefaults] setObject:impl forKey:@"impl"];
            NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
            switch (code) {
                case 1000:
                {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        if ([obj isEqual:[NSNull null]]) {
                            obj = @"";
                        }
                        [dictM setObject:obj forKey:key];
                    }];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:AGENCYDICT];
                    NSString *alias = [dictM objectForKey:@"agencyId"];
                    [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
#if DELETEHUANXIN
                    // (@"注释掉环信")
#else
                    // (@"打开环信代码")
                    // 登录环信↓
                    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                    if (!isLoggedIn) {
                        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                        if (!EMerror) {
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                        }
                    }
                    // 登录环信↑
#endif
                   
                    // 友盟统计开始统计账号
                    [[NSUserDefaults standardUserDefaults] setObject:self.AccountTF.text forKey:@"account"];
                    [[NSUserDefaults standardUserDefaults] setObject:self.PasswordTF.text forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self setJPUSHAlias];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccess object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshManageVCData" object:nil];

                     ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;

                    if (self.tag == 300) {
                        
                        [[NSNotificationCenter  defaultCenter]postNotificationName:@"back" object:nil];

                    }else{

                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        SNTabBarController * main = [[SNTabBarController alloc] init];
                        appDelegate.window.rootViewController = main;
                        
                    }
                    
                }
                    break;
                    
                case 1001:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"密码输入错误" controller:self sleep:1];
                }
                    break;
                case 1002:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"您已被禁号，请联系管理人员" controller:self sleep:1];
                }
                    break;
                case 2000:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"登录失败！" controller:self sleep:1];
                }
                    break;
                    
                case 1004:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"该手机号未注册！" controller:self sleep:1];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [self.view hiddleHud];
    } failed:^(NSString *errorMsg) {
        [self.view hiddleHud];
        [self.view hudShowWithText:@"登录失败，请稍后重试"];
    }];
}

//忘记密码
- (IBAction)forgetClick:(id)sender {
    
    ForgetPasswordViewController *forgetVC = [[ForgetPasswordViewController alloc]init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

//注册
- (IBAction)registeClick:(id)sender {

    RegisterViewController *registeVC = [[RegisterViewController alloc] init];

    [self.navigationController pushViewController:registeVC animated:YES];
  
}

//微信登录
- (void)wechatClick{
    
    SendAuthReq *req = [[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo";
    req.openID = WeChatAPPID;
    req.state = @"1245";
    [WXApi sendReq:req];
}

-(void)wechatDidLoginNotification:(NSNotification *)notiication
{
    NSDictionary *dic = notiication.userInfo;
    NSString *code = [dic objectForKey:@"code"];
    [self loginSuccessByCode:code];
}

#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAPPID,WeChatAPPSECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token    接口调用凭证
         expires_in    access_token接口调用凭证超时时间，单位（秒）
         refresh_token    用户刷新access_token
         openid    授权用户唯一标识
         scope    用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
       // NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* wxCode=[dic valueForKey:@"unionid"];
        NSString* openId = [dic objectForKey:@"openid"];
        
        //[weakSelf requestUserInfoByToken:accessToken andOpenid:wxCode];
        
        NSString *url = [BASEURL stringByAppendingString:Login_weixin];
        if (wxCode.length!=0) {
            NSDictionary *para = @{@"wxCode":wxCode,@"openId":openId};
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    
                    
                    NSDictionary *dict = [responseObj objectForKey:@"agency"];
                    // NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
                    NSString *impl = [dict objectForKey:@"impl"];//是否是执行经理  0 不是 1 是
                    [[NSUserDefaults standardUserDefaults] setObject:impl forKey:@"impl"];
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        if ([obj isEqual:[NSNull null]]) {
                            obj = @"";
                        }
                        [dictM setObject:obj forKey:key];
                    }];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:AGENCYDICT];
                    NSString *alias = [dictM objectForKey:@"agencyId"];
                    [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:DENGLUFANGSHI];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"iswx"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isqq"];
#if DELETEHUANXIN
                    // (@"注释掉环信")
#else
                    // (@"打开环信代码")
                    // 登录环信↓
                    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                    if (!isLoggedIn) {
                        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                        if (!EMerror) {
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                        }
                    }
                    // 登录环信↑
#endif
                    //
                    //                    // 友盟统计开始统计账号
                    //                    //                    [MobClick profileSignInWithPUID:alias];
                    //                    [[NSUserDefaults standardUserDefaults] setObject:self.AccountTF.text forKey:@"account"];
                    //                    [[NSUserDefaults standardUserDefaults] setObject:self.PasswordTF.text forKey:@"password"];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //                    [JPUSHService setTags:nil alias:alias callbackSelector:nil object:nil];
                    
                    [self setJPUSHAlias];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccess object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshManageVCData" object:nil];
                    
                    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    SNTabBarController * main = [[SNTabBarController alloc] init];
                    appDelegate.window.rootViewController = main;
                    
                    
                    
                }
                if ([[responseObj objectForKey:@"code"] intValue]==1001) {
                    bindingphoneVC *vc = [bindingphoneVC new];
                    vc.InActionType = ENUM_ViewControllerweixin;
                    vc.wxToken = wxCode;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([[responseObj objectForKey:@"code"] intValue]==2000) {
                    
                }
            } failed:^(NSString *errorMsg) {
                
            }];
        }
        else
        {
            [[PublicTool defaultTool] publicToolsHUDStr:@"请重新验证" controller:self sleep:1.0];
        }
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic  ==== %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}

-(void)qqclick
{
    _tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQAPPID andDelegate:self];
    _permissionArray = [NSMutableArray arrayWithObjects: kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,nil];
    [_tencentOAuth authorize:_permissionArray inSafari:NO];
}

- (void)tencentDidLogin{
    if (_tencentOAuth.accessToken) {
        [_tencentOAuth getUserInfo];
        NSString *openId = _tencentOAuth.openId;
        //NSString *qqOpenId = _tencentOAuth.openId;
        NSString *qqToken = _tencentOAuth.accessToken;
        NSLog(@"id-----%@",openId);
        
        
        
        NSString *newurl = [NSString stringWithFormat:@"%@%@%@",@"https://graph.qq.com/oauth2.0/me?access_token=",qqToken,@"&unionid=1"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/javascript" ,@"text/plain",@"text/html" , nil];
        [manager GET:newurl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
            NSString *resultString  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *str2 = [resultString substringFromIndex:9];
            NSString *str1 = [str2 substringToIndex:str2.length-3];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[str1 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"dic:%@",dic);
            NSString *unionid = [dic objectForKey:@"unionid"];
            NSLog(@"unic-----%@",unionid);
            
            
            NSDictionary *para = @{@"qqOpenId":unionid,@"qqToken":qqToken};
            NSString *url = [BASEURL stringByAppendingString:Login_qq];
            [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
                
                
                if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                    
                    
                    NSDictionary *dict = [responseObj objectForKey:@"agency"];
                    // NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
                    NSString *impl = [dict objectForKey:@"impl"];//是否是执行经理  0 不是 1 是
                    [[NSUserDefaults standardUserDefaults] setObject:impl forKey:@"impl"];
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        if ([obj isEqual:[NSNull null]]) {
                            obj = @"";
                        }
                        [dictM setObject:obj forKey:key];
                    }];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:AGENCYDICT];
                    NSString *alias = [dictM objectForKey:@"agencyId"];
                    [[NSUserDefaults standardUserDefaults] setObject:alias forKey:@"alias"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:DENGLUFANGSHI];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isqq"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"iswx"];
#if DELETEHUANXIN
                    // (@"注释掉环信")
#else
                    // (@"打开环信代码")
                    // 登录环信↓
                    BOOL isLoggedIn = [EMClient sharedClient].isLoggedIn;
                    if (!isLoggedIn) {
                        UserInfoModel *model = [[PublicTool defaultTool]publicToolsGetUserInfoModelFromDict];
                        EMError *EMerror = [[EMClient  sharedClient]loginWithUsername:model.huanXinId password:model.huanXinPassword];
                        if (!EMerror) {
                            [[EMClient sharedClient].options setIsAutoLogin:YES];
                        }
                    }
                    // 登录环信↑
#endif
                    //
                    //                    // 友盟统计开始统计账号
                    //                    //                    [MobClick profileSignInWithPUID:alias];
                    //                    [[NSUserDefaults standardUserDefaults] setObject:self.AccountTF.text forKey:@"account"];
                    //                    [[NSUserDefaults standardUserDefaults] setObject:self.PasswordTF.text forKey:@"password"];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //                    [JPUSHService setTags:nil alias:alias callbackSelector:nil object:nil];
                    
                    [self setJPUSHAlias];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginSuccess object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshManageVCData" object:nil];
                    
                    
                    
                    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
                    
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    SNTabBarController * main = [[SNTabBarController alloc] init];
                    appDelegate.window.rootViewController = main;
                    
                    
                    
                }
                if ([[responseObj objectForKey:@"code"] intValue]==1001) {
                    bindingphoneVC *vc = [bindingphoneVC new];
                    vc.InActionType = ENUM_ViewControllerqq;
                    vc.qqOpenId = unionid;
                    vc.qqToken = qqToken;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                if ([[responseObj objectForKey:@"code"] intValue]==2000) {
                    
                }
            } failed:^(NSString *errorMsg) {
                
            }];
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    
        
    }else{
        NSLog(@"accessToken 没有获取成功");
    }
}



- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions{
    
    // incrAuthWithPermissions是增量授权时需要调用的登录接口
    // permissions是需要增量授权的权限列表
    [tencentOAuth incrAuthWithPermissions:permissions];
    return NO; // 返回NO表明不需要再回传未授权API接口的原始请求结果；
    // 否则可以返回YES
}

- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    return YES;
}

- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    NSLog(@"增量授权完成");
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    { // 在这里第三方应用需要更新自己维护的token及有效期限等信息
        // **务必在这里检查用户的openid是否有变更，变更需重新拉取用户的资料等信息** _labelAccessToken.text = tencentOAuth.accessToken;

    }
    else
    {
        NSLog(@"增量授权不成功，没有获取accesstoken");
    }
    
}

- (void)getUserInfoResponse:(APIResponse*) response{
    NSLog(@" response %@",response);
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)dealloc
{
    ((SNNavigationController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.childViewControllers[3]).navigationBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechatDidLoginNotification" object:nil];
}

- (IBAction)backClick:(id)sender {
    
    if (self.tag == 300) {
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"back" object:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
