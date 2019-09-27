//
//  SettingViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SettingViewController.h"
#import "PasswordViewController.h"
#import "PhoneNumberViewController.h"
#import "BundledWeChatTableViewCell.h"
#import "LoginViewController.h"
#import <JPUSHService.h>
#import "ZCHSettingChangeNetController.h"
#import "AppDelegate.h"
#import <AFHTTPSessionManager.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "InOutCompanyModel.h"
#import "ChangeCompanyInOrOutNetStateController.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource,TencentSessionDelegate>
{
    BOOL _isBundled;
    TencentOAuth *_tencentOAuth;
    NSMutableArray *_permissionArray;   //权限列表
}

@property (nonatomic, strong) UITableView *settingTableView;
// 如果可以切换内外网。 listArr存放公司列表数据，如果不能切换内外网， listArr为空
@property (strong, nonatomic) NSMutableArray *listArr;
@property (nonatomic, assign) BOOL isOutNet; // 是否是外网
@property (strong, nonatomic) UIView *bottomView;
@property (nonatomic,copy)    NSString *isshow;
@property (nonatomic,copy)    NSString *wxToken;
@property (nonatomic,copy)    NSString *qqOpenId;

@property (nonatomic, strong) NSMutableArray *tableViewItemArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"设置";
    _isOutNet = NO;
    self.isshow = [[NSUserDefaults standardUserDefaults] objectForKey:DENGLUFANGSHI];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT];
    self.wxToken = [dic objectForKey:@"wxToken"];
    self.qqOpenId = [dic objectForKey:@"qqOpenId"];
    
    NSString *isqq = [[NSUserDefaults standardUserDefaults] objectForKey:@"isqq"];
    NSString *iswx = [[NSUserDefaults standardUserDefaults] objectForKey:@"iswx"];
    
    if ([self.isshow isEqualToString:@"1"]) {
        if ([isqq isEqualToString:@"1"]) {
            self.tableViewItemArray = [@[@"微信绑定",@"清除缓存", @"版本号"] mutableCopy];
        }
        if ([iswx isEqualToString:@"1"]) {
            self.tableViewItemArray = [@[@"QQ绑定",@"清除缓存", @"版本号"] mutableCopy];
        }
//        if (self.wxToken.length!=0&&self.qqOpenId.length!=0) {
//            self.tableViewItemArray = [@[@"微信绑定", @"QQ绑定",@"清除缓存", @"版本号"]mutableCopy];
//        }
    } else {
        self.tableViewItemArray = [@[@"修改密码",@"微信绑定", @"QQ绑定",@"清除缓存", @"版本号"]mutableCopy];
    }
    
    self.listArr = [NSMutableArray array];
    self.view.backgroundColor = Bottom_Color;
    NSUserDefaults *standUserDefault = [NSUserDefaults standardUserDefaults];
    [standUserDefault setBool:NO forKey:kBindWeiXin];
    _isBundled = [standUserDefault boolForKey:kBindWeiXin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindWeiXin) name:kWeiXinBindSuccess object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatDidLoginNotification:) name:@"bangdingeweixin" object:nil];
    
    [self createTableView];
    [self createUI];
    

  
    
}
// 接收到微信绑定成功通知
- (void)bindWeiXin {
    
    NSUserDefaults *standUserDefault = [NSUserDefaults standardUserDefaults];
    [standUserDefault setBool:YES forKey:kBindWeiXin];
    [standUserDefault synchronize];
    _isBundled = YES;
    BundledWeChatTableViewCell *cell = [self.settingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    cell.bundledLabel.text = @"已绑定";
    
}

// 获取是否可以切换内网状态和数据
- (void)setData {
    
    NSString *url = [BASEURL stringByAppendingString:@"construction/getNetStatus.do"];
    NSDictionary *param = @{
                            @"agencyId" : @([[[[NSUserDefaults standardUserDefaults] objectForKey:AGENCYDICT] objectForKey:@"agencyId"] integerValue])
                            };
    [NetManager afPostRequest:url parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            NSArray *listData = [NSMutableArray arrayWithArray:responseObj[@"data"][@"companyList"]];
             [self.listArr removeAllObjects];
            self.listArr = [[NSArray yy_modelArrayWithClass:[InOutCompanyModel class] json:listData] mutableCopy];
            if (self.listArr.count > 0) {
                if (self.isshow) {
                    self.tableViewItemArray = [@[@"清除缓存", @"版本号"] mutableCopy];
                } else {
                    self.tableViewItemArray = [@[@"修改密码",@"微信绑定", @"QQ绑定",@"清除缓存", @"版本号"]mutableCopy];
                }
                [self.settingTableView reloadData];
            }
            _isOutNet = responseObj[@"data"][@"isOuter"]; // 内外网标识 0:外网选中，1:不选
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}


- (void)createUI {
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, 100)];
    bottomView.backgroundColor = Bottom_Color;
    self.bottomView = bottomView;
    self.settingTableView.tableFooterView = bottomView;

    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"退        出" forState:UIControlStateNormal];
    [sureBtn setTitleColor:White_Color forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:Main_Color];
    sureBtn.layer.cornerRadius = 5;
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.view.mas_left).offset(8);
        make.right.equalTo(self.view.mas_right).offset(-8);
        make.height.equalTo(@44);
        make.top.equalTo(bottomView.mas_top).offset(20);
    }];
    

    UILabel *companyLabel = [[UILabel alloc]init];
    companyLabel.text = @"北京比邻而居科技有限公司版权所有";
    companyLabel.textColor = [UIColor darkGrayColor];
    [companyLabel setFont:[UIFont systemFontOfSize:10.0]];
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.backgroundColor = Clear_Color;
    
    [self.view addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(0);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
        make.bottom.equalTo(-5);
    }];
}

- (void)createTableView {
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    if (IphoneX) {
        tableView.frame = CGRectMake(0, 88 + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - 88 - 5);
    } else {
        tableView.frame = CGRectMake(0, 64 + 5, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 5);
    }
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = Bottom_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:tableView];
    
    self.settingTableView = tableView;
    
    [self.settingTableView registerNib:[UINib nibWithNibName:@"BundledWeChatTableViewCell" bundle:nil] forCellReuseIdentifier:@"BundledWeChatTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.tableViewItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0000000000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BundledWeChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BundledWeChatTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = White_Color;
    cell.textLabel.text = self.tableViewItemArray[indexPath.section];
    if ([cell.textLabel.text isEqualToString:@"微信绑定"]) {
        cell.bundledLabel.text = self.wxToken.length>0?@"已经绑定":@"未绑定";
    }
    if ([cell.textLabel.text isEqualToString:@"QQ绑定"]) {
        cell.bundledLabel.text = self.qqOpenId.length>0?@"已经绑定":@"未绑定";
    }
    if ([cell.textLabel.text isEqualToString:@"版本号"]) {
        cell.bundledLabel.text = [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    for (NSString *text in @[@"修改密码", @"清除缓存"]) {
        if ([cell.textLabel.text isEqualToString:text]) {
            cell.bundledLabel.text = @"";
        }
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BundledWeChatTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    if ([text isEqualToString:@"修改密码"]) {
        PasswordViewController *passwordVC = [[PasswordViewController alloc]init];
        [self.navigationController pushViewController:passwordVC animated:YES];
    }
    if ([text isEqualToString:@"微信绑定"]) {
        
        if (IsNilString(self.wxToken)) {
            //绑定
            [self bundleWeChat];
        }
        else
        {
            //解除绑定
            
            [self wxjiechubangding];
        }
    }
    if ([text isEqualToString:@"QQ绑定"]) {
        
        if (IsNilString(self.qqOpenId))
        {
            [self qqclick];
        }
        else
        {
            [self qqjiechubangding];
        }
    }
    if ([text isEqualToString:@"切换网络"]) {
        ChangeCompanyInOrOutNetStateController *vc = [ChangeCompanyInOrOutNetStateController new];
        vc.listArray = self.listArr;
        vc.isOutNet = _isOutNet;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([text isEqualToString:@"清除缓存"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清除缓存数据?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self clearCache];
            
            [[PublicTool defaultTool] publicToolsHUDStr:@"正在清理缓存.." controller:self sleep:2.5];
            
        }];
        
        [alert addAction:sureAction];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)bundleWeChat {
    
    if ([WXApi isWXAppInstalled]) {
        
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.state = @"12456";
        [WXApi sendReq:req];

        
        NSLog(@"success");
    }else{
        
        NSLog(@"install");
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self.settingTableView reloadData];
}

#pragma mark 微信回调。

-(void)wechatDidLoginNotification:(NSNotification *)notiication
{
    NSDictionary *dic = notiication.userInfo;
    NSString *code = [dic objectForKey:@"code"];
    [self loginSuccessByCode:code];
}

-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WeChatAPPID,WeChatAPPSECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);

        NSString *openid = [dic objectForKey:@"unionid"];
        [self bangdingweixinwxCode:openid];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)bangdingweixinwxCode:(NSString *)code
{
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *agencyIdStr = @"";
    
        agencyIdStr = [NSString stringWithFormat:@"%ld", agencyid];
        NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
        [paramDic setObject:agencyIdStr forKeyedSubscript:@"agencyId"];
        [paramDic setObject:code forKeyedSubscript:@"wxCode"];
        NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/bandWx.do"];
        [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                self.wxToken = code;
                [[PublicTool defaultTool] publicToolsHUDStr:@"绑定成功" controller:self sleep:1.0];
                [self.settingTableView reloadData];
            }
        } failed:^(NSString *errorMsg) {
            
        }];


}

-(void)wxjiechubangding
{
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *agencyIdStr = @"";
    agencyIdStr = [NSString stringWithFormat:@"%ld", agencyid];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:agencyIdStr forKeyedSubscript:@"agencyId"];
    [paramDic setObject:@"" forKeyedSubscript:@"wxCode"];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"agency/bandWx.do"];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1003) {
            self.wxToken = @"";
            [[PublicTool defaultTool] publicToolsHUDStr:@"解绑成功" controller:self sleep:1.0];
            [self.settingTableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
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
        NSLog(@"id-----%@",openId);
        NSString *qqToken = _tencentOAuth.accessToken;
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
            NSDictionary *dict = @{@"qqOpenId":unionid,@"qqToken":qqToken};
            [self bangdingqq:dict];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
        
      
    }else{
        NSLog(@"accessToken 没有获取成功");
    }
}

-(void)bangdingqq:(NSDictionary *)dic
{
    NSString *qqOpenId = [dic objectForKey:@"qqOpenId"];
    NSString *qqToken = [dic objectForKey:@"qqToken"];
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *agencyIdStr = @"";
    agencyIdStr = [NSString stringWithFormat:@"%ld", agencyid];
    NSString *url = [BASEURL stringByAppendingString:BANGDING_QQ];
        NSDictionary *para = @{@"qqOpenId":qqOpenId,@"qqToken":qqToken,@"agencyId":agencyIdStr};
        [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
            if ([[responseObj objectForKey:@"code"] intValue]==1000) {
                self.qqOpenId = qqOpenId;
                [[PublicTool defaultTool] publicToolsHUDStr:@"绑定成功" controller:self sleep:1.0];
                [self.settingTableView reloadData];
            }
            
        } failed:^(NSString *errorMsg) {
            
        }];
 
}

-(void)qqjiechubangding
{
  
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    NSString *agencyIdStr = @"";
    agencyIdStr = [NSString stringWithFormat:@"%ld", agencyid];
    NSString *url = [BASEURL stringByAppendingString:BANGDING_QQ];
    NSDictionary *para = @{@"qqOpenId":@"",@"qqToken":@"",@"agencyId":agencyIdStr};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1003) {
            self.qqOpenId = @"";
            [[PublicTool defaultTool] publicToolsHUDStr:@"解绑成功" controller:self sleep:1.0];
            [self.settingTableView reloadData];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)clearCache {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSArray * files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
        NSLog(@"files:%lu",(unsigned long)[files count]);
        
        for (NSString * p in files) {
            NSError * error;
            NSString * path = [cachePath stringByAppendingPathComponent:p];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
    });
}

#pragma mark -- 退出登录
- (void)sureClick:(UIButton*)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确认退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

#if DELETEHUANXIN
        // (@"注释掉环信")
#else
        // (@"打开环信代码")
        //环信退出登录
        EMError *EMerror = [[EMClient sharedClient] logout:YES];
        if (!EMerror) {
            YSNLog(@"环信退出成功");
        }
#endif
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:AGENCYDICT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"impl"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alias"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:DENGLUFANGSHI];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isqq"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iswx"];
        
        // 友盟统计停止统计账号
        //        [MobClick profileSignOff];
        //            极光推送退出账号
        
        [JPUSHService setTags:nil alias:@"logout" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias)
         {
             YSNLog(@"iResCode: %d, alias: %@", iResCode, iAlias);
         }];
        
        //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceTokenData"];
        //        [JPUSHService registerDeviceToken:nil];
        
        //((AppDelegate *)[[UIApplication sharedApplication] delegate]).appRootTabBarVC.selectedIndex = 0;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        SNTabBarController * main = [[SNTabBarController alloc] init];
        appDelegate.window.rootViewController = main;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshUserState" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeVCData" object:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshManageVCData" object:nil];
        // 发送通知，清空消息数量
        [[NSNotificationCenter defaultCenter] postNotificationName:klognOutNotification object:nil];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)tableViewItemArray {
    if (_tableViewItemArray == nil) {
        _tableViewItemArray = [NSMutableArray array];
    }
    return _tableViewItemArray;
}

@end
