//
//  bindingphoneVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "bindingphoneVC.h"
#import "bindingphoneCell0.h"
#import "bindingphoneCell1.h"
#import "AppDelegate.h"
#import "topView.h"
#import "AppDelegate.h"
#import <JPUSHService.h>

#import "bindingphoneCell2.h"

@interface bindingphoneVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) topView *tview;
@property (nonatomic,strong) UIView *bgView;
@property (copy, nonatomic) NSString *codeOfImage;

@end

static NSString *bindingidentfid0 = @"bindingidentfid0";
static NSString *bindingidentfid1 = @"bindingidentfid1";
static NSString *bindingidentfid2 = @"bindingidentfid2";
static NSString *bindingidentfid3 = @"bindingidentfid3";

@implementation bindingphoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"绑定手机";
    [self.view addSubview:self.table];
    self.table.tableFooterView = self.footView;
    [self showView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(void)showView
{
    //1. 取出window
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    _bgView = [[UIView alloc]init];
    _bgView.frame = window.bounds;
    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [window addSubview:_bgView];
    [window addSubview:self.tview];
    [window addSubview:self.view];

}

-(topView *)tview
{
    if(!_tview)
    {
        _tview = [[topView alloc] initWithFrame:CGRectMake(45, 130, kSCREEN_WIDTH-90, 400)];
        _tview.backgroundColor = [UIColor whiteColor];
        [_tview.hidBtn addTarget:self action:@selector(hidbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tview;
}

-(UITableView *)table
{
    if(!_table)
    {
        CGFloat bottomfl = 0.01f;
        if (isiPhoneX) {
            bottomfl = 88;
        }
        else
        {
            bottomfl = 64;
        }
        CGFloat naviBottom = kSCREEN_HEIGHT-bottomfl;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, bottomfl, BLEJWidth, naviBottom) style:UITableViewStylePlain];
        
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundColor = kBackgroundColor;
    }
    return _table;
}

-(UIView *)footView
{
    if(!_footView)
    {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = kBackgroundColor;
        _footView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 200);
        [_footView addSubview:self.submitBtn];
        [_footView addSubview:self.contentLab];
    }
    return _footView;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.frame = CGRectMake(10, 45, kSCREEN_WIDTH-20, 38);
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 5;
        [_submitBtn setTitle:@"提交" forState:normal];
        _submitBtn.backgroundColor = Main_Color;
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_submitBtn addTarget:self action:@selector(submitbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        _contentLab.frame = CGRectMake(10, self.submitBtn.bottom+20, kSCREEN_WIDTH-20, 150);
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
        _contentLab.text = @"* 此邀请码为选填项\n\n* 绑定手机可以提高账号安全，方便找回密码 拷贝\n\n* 根据国家互联网信息办公室发布的《移动互联网应用程序信息服务管理规定》，自2016年8月20日起，注册用户需基于移动电话号码进行实名认证";
    }
    return _contentLab;
}

#pragma mark - 实现方法

-(void)submitbtnClick
{
    if (self.InActionType==ENUM_ViewControllerweixin) {
        [self loginforweixin];
    }
    else
    {
        [self loginforqq];
    }
}

-(void)loginforweixin
{
    NSString *phone = @"";
    NSString *code = @"";
    NSString *wxToken = @"";
    NSString *inviteCode = @"";
    
    UITextField *text0 = [self.table viewWithTag:201];
    UITextField *text1 = [self.table viewWithTag:202];
    UITextField *text2 = [self.table viewWithTag:203];
    if (text0.text.length==0) {
        
    }
    else
    {
        phone = text0.text;
    }
    if (text1.text.length==0) {
        
    }
    else
    {
        code = text1.text;
    }
    if (text2.text.length==0) {
        
    }
    else
    {
        inviteCode = text2.text;
    }
    if (self.wxToken.length==0) {
        
    }
    else
    {
        wxToken = self.wxToken;
    }
    NSDictionary *para = @{@"wxToken":wxToken,@"phone":phone,@"code":code,@"inviteCode":inviteCode};
    NSString *url = [BASEURL stringByAppendingString:Login_disanfang];
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            
            
            NSDictionary *dict = [responseObj objectForKey:@"agency"];
            NSString *impl = [dict objectForKey:@"impl"];//是否是执行经理  0 不是 1 是
            [[NSUserDefaults standardUserDefaults] setObject:impl forKey:@"impl"];
            
           // NSInteger code = [[responseObj objectForKey:@"code"] integerValue];
      
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
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isqq"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"iswx"];
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
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)loginforqq
{
    NSString *phone = @"";
    NSString *code = @"";
    NSString *inviteCode = @"";
    NSString *qqToken = @"";
    NSString *qqOpenId = @"";
    
    UITextField *text0 = [self.table viewWithTag:201];
    UITextField *text1 = [self.table viewWithTag:202];
    UITextField *text2 = [self.table viewWithTag:203];
    if (text0.text.length==0) {
        
    }
    else
    {
        phone = text0.text;
    }
    if (text1.text.length==0) {
        
    }
    else
    {
        code = text1.text;
    }
    if (text2.text.length==0) {
        
    }
    else
    {
        inviteCode = text2.text;
    }
    if (self.qqToken.length==0) {
        
    }
    else
    {
        qqToken = self.qqToken;
    }
    if (self.qqOpenId.length==0) {
        
    }
    else
    {
        qqOpenId = self.qqOpenId;
    }
    NSDictionary *para = @{@"qqOpenId":qqOpenId,@"phone":phone,@"code":code,@"inviteCode":inviteCode,@"qqToken":qqToken};
    NSString *url = [BASEURL stringByAppendingString:Login_disanfang];
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
    } failed:^(NSString *errorMsg) {
        
    }];
}

- (void)checkWithCell:(bindingphoneCell1 *)cell {
    UITextField *phonetext = [self.table viewWithTag:201];
    if (phonetext.text.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入手机号" controller:self sleep:1.5];
    }else if (IsNilString(self.codeOfImage)) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入图形验证码" controller:self sleep:1.5];
    }else{
        [self fasongyanzhengma];
        [cell.setBtn fire];
    }
}

- (void)fasongyanzhengma {
    UITextField *phonetext = [self.table viewWithTag:201];
    NSString *url = [BASEURL stringByAppendingString:SMS_GET];
    NSString *str = [self getuuid];
    NSDictionary *para = @{@"phone":phonetext.text,@"smsType":@"1",@"v":str,@"code":self.codeOfImage};
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] intValue]==1000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"成功" controller:self sleep:1.5];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==1002) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"超过当天数量限制" controller:self sleep:1.5];
        }
        if ([[responseObj objectForKey:@"code"] intValue]==2000) {
            [[PublicTool defaultTool] publicToolsHUDStr:@"失败" controller:self sleep:1.5];
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

-(void)hidbtnclick
{
    [self.bgView removeFromSuperview];
    [self.tview removeFromSuperview];
}

#pragma mark -UITableViewDataSource&&UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }
    else
    {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            bindingphoneCell0 *cell = [tableView dequeueReusableCellWithIdentifier:bindingidentfid0];
            if (!cell) {
                cell = [[bindingphoneCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bindingidentfid0];
                cell.phoneText.tag = 201;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.phoneText.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
        }
        if (indexPath.row==1) {
            bindingphoneCell2 *cell = [tableView dequeueReusableCellWithIdentifier:bindingidentfid3];
            if (!cell) {
                cell = [[bindingphoneCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bindingidentfid3];
            }
            cell.codeText.keyboardType = UIKeyboardTypeDefault;
            cell.block = ^(NSString *string) {
                self.codeOfImage = string;
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row==2) {
            bindingphoneCell1 *cell = [tableView dequeueReusableCellWithIdentifier:bindingidentfid1];
            if (!cell) {
                cell = [[bindingphoneCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bindingidentfid1];
                cell.codeText.tag = 202;
            }
            cell.blockDidTouchButton = ^{
                [self checkWithCell:cell];
            };
            cell.codeText.keyboardType = UIKeyboardTypeNumberPad;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section==1) {
        bindingphoneCell0 *cell = [tableView dequeueReusableCellWithIdentifier:bindingidentfid2];
        if (!cell) {
            cell = [[bindingphoneCell0 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bindingidentfid2];
            cell.phoneText.tag = 203;
        }
        cell.phoneText.keyboardType = UIKeyboardTypeDefault;
        cell.phoneText.placeholder = @"请输入推广邀请码";
        cell.leftLab.text = @"邀请码";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 10)];
        view.backgroundColor = kBackgroundColor;
        return view;
    }
    else
    {
        return nil;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 10;
    }
    else
    {
        return 0.01f;
    }
    return 0.01f;
}

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


-(NSString *)getuuid
{
    UIDevice *device = [UIDevice currentDevice];//创建设备对象
    NSUUID *UUID = [device identifierForVendor];
    NSString *deviceID = @"";
    deviceID = [UUID UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@",deviceID);
    return deviceID;
}


@end
