//
//  RegisterViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RegisterViewController.h"
#import "SendMessageApi.h"
#import "JudgeIsRegistedApi.h"
#import "VerifyIdentifyCodeApi.h"
#import "RegisterInfoViewController.h"
#import "ZCHPublicWebViewController.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{
    CGFloat height;
}
//@property (strong, nonatomic)  UIButton *checkCodeBtn;
@property (strong, nonatomic)  UITextField *phoneNumberTF;
@property (strong, nonatomic)  UITextField *IdentifyTF;
@property (strong, nonatomic)  UIButton *IdentifyBtn;
@property (strong, nonatomic)  UIButton *FinishBtn;
@property (strong, nonatomic)  UITextField *promoteCodeTF;
@property (strong, nonatomic)  UIButton *protocolBtn;
@property (strong, nonatomic)  UILabel *leftLab;

@property (strong, nonatomic)  UIImageView *codeimg;
@property (strong, nonatomic)  UITextField *codetext;
@end



@implementation RegisterViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI {
    
    self.title = @"注册";
    self.view.backgroundColor = Bottom_Color;
    
    self.navigationController.navigationBar.barTintColor = Main_Color;
    
    
    [self.view addSubview:self.phoneNumberTF];
    [self.view addSubview:self.IdentifyTF];
    [self.view addSubview:self.IdentifyBtn];
    [self.view addSubview:self.promoteCodeTF];
    [self.view addSubview:self.leftLab];
    [self.view addSubview:self.FinishBtn];
    [self.view addSubview:self.protocolBtn];
    
    [self.view addSubview:self.codeimg];
    [self.view addSubview:self.codetext];
    
    if (KIsiPhoneX) {
        height = 88;
    }
    else
    {
        height = 64;
    }
    
    [self setuplauout];
    
    [self refreshimg];
}

-(void)refreshimg
{
    NSString *url = [BASEURL stringByAppendingString:tupianyanzhengma];
    NSString *str = [self getuuid];
    NSString *imgurl = [NSString stringWithFormat:@"%@%@%@",url,@"?v=",str];
    [_codeimg sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:nil options:SDWebImageRefreshCached];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;

    [weakSelf.phoneNumberTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(30*WIDTH_SCALE);
        make.right.equalTo(weakSelf.view).with.offset(-30*WIDTH_SCALE);
        make.height.mas_offset(40);
        make.top.equalTo(weakSelf.view).with.offset(height+30*HEIGHT_SCALE);
    }];
    
    [weakSelf.codeimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-30*WIDTH_SCALE);
        make.height.mas_offset(40);
        make.top.equalTo(weakSelf.view).with.offset(height+30*HEIGHT_SCALE+60);
        make.width.mas_offset(80);
    }];
    
    [weakSelf.codetext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneNumberTF);
        make.top.equalTo(weakSelf.codeimg);
        make.height.mas_offset(40);
        make.right.equalTo(weakSelf.codeimg.mas_left);
    }];
    
    [weakSelf.IdentifyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).with.offset(30*WIDTH_SCALE);
        make.right.equalTo(weakSelf.view).with.offset(-30*WIDTH_SCALE);
        make.height.mas_offset(40);
        make.top.equalTo(weakSelf.codetext.mas_bottom).with.offset(20);
    }];
    
    [weakSelf.IdentifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).with.offset(-30*WIDTH_SCALE);
        make.height.mas_offset(40);
        make.top.equalTo(weakSelf.IdentifyTF);
        make.width.mas_offset(80);
    }];
    
    [weakSelf.promoteCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneNumberTF);
        make.right.equalTo(weakSelf.phoneNumberTF);
        make.height.mas_offset(40);
        make.top.equalTo(weakSelf.IdentifyBtn.mas_bottom).with.offset(20);
    }];

    
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.IdentifyBtn);
        make.top.equalTo(weakSelf.IdentifyBtn.mas_bottom).with.offset(30);
        make.width.mas_offset(200);
    }];
    
    [weakSelf.FinishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.IdentifyTF);
        make.right.equalTo(weakSelf.IdentifyBtn);
        make.height.mas_offset(40);
        make.top.equalTo(weakSelf.IdentifyBtn.mas_bottom).with.offset(30);
    }];
    
    [weakSelf.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.FinishBtn);
        make.top.equalTo(self.FinishBtn.mas_bottom).equalTo(5);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
}

//返回按钮
- (void)backBtn:(UIBarButtonItem*)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//获取验证码
- (void)identifyClick:(id)sender {
    
//    校验手机号码正则
    BOOL isCorrect = [[PublicTool defaultTool] publicToolsCheckTelNumber:self.phoneNumberTF.text];
    
    if (!isCorrect) {
        
        [[PublicTool defaultTool] publicToolsSureAlertInfo:@"请输入正确的手机号码" controller:self];
        
        return;
        
    }else{
        
        NSString *phone = self.phoneNumberTF.text;
       
        
        JudgeIsRegistedApi *judgeApi = [[JudgeIsRegistedApi alloc]initWithPhoneNumber:phone];

        [judgeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {

            NSDictionary *dic = request.responseJSONObject;

            if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]) {

                [self getIdentifyCodeWithPhone:phone smsType:@"1"];

            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1001"]){
                //[self getIdentifyCodeWithPhone:phone smsType:@"1"];
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"该手机号已注册" controller:self];
                
                return ;
            }

        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            // 你可以直接在这里使用 self
            
        }];
    }
}

//完成按钮
- (void)finishClick:(id)sender {
    
    [self.view endEditing:YES];
    NSString *phone = self.phoneNumberTF.text;
    NSString *code = self.IdentifyTF.text;
    NSString *inviteCode = [NSString new];
    if (self.promoteCodeTF.text.length==0) {
        inviteCode = @"";
    }
    else
    {
        inviteCode = self.promoteCodeTF.text;
    }
    //    校验手机号码正则
    BOOL isCorrect = [[PublicTool defaultTool] publicToolsCheckTelNumber:self.phoneNumberTF.text];
    if (!isCorrect) {

        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"手机号有误"];
        return;
    }
    if (phone.length != 0 && code.length != 0) {
    
        VerifyIdentifyCodeApi *verifyApi = [[VerifyIdentifyCodeApi alloc]initWithPhoneNumber:phone code:code];
        
        [verifyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSDictionary *dic = request.responseJSONObject;
            
            NSString *phoneCode = @"";
            if (self.codetext.text.length==0) {
                
            }
            else
            {
                phoneCode = self.codetext.text;
            }
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]) {
                
                RegisterInfoViewController *infoVC = [[RegisterInfoViewController alloc]init];
                infoVC.phone = phone;
                infoVC.inviteCode = inviteCode;
                infoVC.phoneCode = self.IdentifyTF.text;
                [self.navigationController pushViewController:infoVC animated:YES];
                
                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1001"]){
                
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"短信验证码错误" controller:self];
                
                return ;
            } else {
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"操作繁忙，请您稍后再试。。。" controller:self];
                return;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"请检查网络或稍后再试。。。" controller:self];
        }];
        
    }else{
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写手机号和验证码" controller:self sleep:1];
        
        return;
    }

}

//得到验证码
- (void)getIdentifyCodeWithPhone:(NSString*)phone smsType:(NSString*)smsType {
    
    NSString *code =@"";
    if (self.codetext.text.length==0) {
        
    }
    else
    {
        code = self.codetext.text;
    }
    
    NSString *url = [BASEURL stringByAppendingString:SMS_GET];
    NSString *str = [self getuuid];

    NSDictionary *para = @{@"phone":phone,@"code":code,@"v":str};
    
    [NetManager afPostRequest:url parms:para finished:^(id responseObj) {
        if ([[responseObj objectForKey:@"code"] isEqualToString:@"1000"]) {
            
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码发送成功" controller:self];
            __block int timeout = 120; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                
                if(timeout <= 0) { //倒计时结束，关闭
                    
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.IdentifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.IdentifyBtn.userInteractionEnabled = YES;
                        self.IdentifyBtn.backgroundColor = kMainThemeColor;
                    });
                    
                } else {
                    
                    int seconds = timeout;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //NSLog(@"____%@",strTime);
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [self.IdentifyBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        self.IdentifyBtn.userInteractionEnabled = NO;
                        self.IdentifyBtn.backgroundColor = kDisabledColor;
                    });
                    timeout--;
                }
            });
            
            dispatch_resume(_timer);
            
            return ;
            
        } else if ([[responseObj objectForKey:@"code"] isEqualToString:@"1002"]){
            
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"今日短信次数已用完，请明日再试" controller:self];
            
            return ;
            
        }else if ([[responseObj objectForKey:@"code"] isEqualToString:@"1003"]){
            
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"图片验证码错误" controller:self];
            
            return ;
        }
        else {
            
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码发送失败" controller:self];
            
            return ;
        }
    } failed:^(NSString *errorMsg) {
        
    }];
}

#pragma mark - 注册协议的点击事件
- (void)didClickProtocolBtn:(UIButton *)btn {
    
    ZCHPublicWebViewController *VC = [[ZCHPublicWebViewController alloc] init];
    VC.titleStr = @"注册协议";
    VC.webUrl = @"resources/html/wel.html";
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)dealloc {
    
//    self.returnKeyHandler = nil;
}

#pragma mark - getters

-(UITextField *)phoneNumberTF
{
    if(!_phoneNumberTF)
    {
        _phoneNumberTF = [[UITextField alloc] init];
        _phoneNumberTF.delegate = self;
        _phoneNumberTF.placeholder = @"  请输入手机号";
        _phoneNumberTF.layer.borderColor = [UIColor hexStringToColor:@"999999"].CGColor; // set color as you want.
        _phoneNumberTF.layer.borderWidth = 1.0; // set borderWidth as you want.
    }
    return _phoneNumberTF;
}

-(UITextField *)IdentifyTF
{
    if(!_IdentifyTF)
    {
        _IdentifyTF = [[UITextField alloc] init];
        _IdentifyTF.delegate = self;
        _IdentifyTF.placeholder = @"  请输入验证码";
        _IdentifyTF.layer.borderColor = [UIColor hexStringToColor:@"999999"].CGColor; // set color as you want.
        _IdentifyTF.layer.borderWidth = 1.0; // set borderWidth as you want.
    }
    return _IdentifyTF;
}


-(UITextField *)promoteCodeTF
{
    if(!_promoteCodeTF)
    {
        _promoteCodeTF = [[UITextField alloc] init];
        _promoteCodeTF.delegate = self;
        _promoteCodeTF.placeholder = @"请输入分销员邀请码（选填）";
        _promoteCodeTF.layer.borderColor = [UIColor hexStringToColor:@"999999"].CGColor; // set color as you want.
        _promoteCodeTF.layer.borderWidth = 1.0; // set borderWidth as you want.
        [_promoteCodeTF setHidden:YES];
    }
    return _promoteCodeTF;
}

-(UIButton *)IdentifyBtn
{
    if(!_IdentifyBtn)
    {
        _IdentifyBtn = [[UIButton alloc] init];
        [_IdentifyBtn addTarget:self action:@selector(identifyClick:) forControlEvents:UIControlEventTouchUpInside];
        [_IdentifyBtn setTitle:@"发送验证码" forState:normal];
        _IdentifyBtn.backgroundColor = Main_Color;
        _IdentifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_IdentifyBtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _IdentifyBtn;
}

-(UIButton *)FinishBtn
{
    if(!_FinishBtn)
    {
        _FinishBtn = [[UIButton alloc] init];
        [_FinishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        [_FinishBtn setTitle:@"完成" forState:normal];
        _FinishBtn.backgroundColor = Main_Color;
        _FinishBtn.layer.masksToBounds = YES;
        _FinishBtn.layer.cornerRadius = 4;
        [_FinishBtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _FinishBtn;
}


-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.text = @"*此邀请码为选填项";
        _leftLab.textColor = [UIColor hexStringToColor:@"333333"];
        _leftLab.font = [UIFont systemFontOfSize:12];
        [_leftLab setHidden:YES];
    }
    return _leftLab;
}



-(UIButton *)protocolBtn
{
    if(!_protocolBtn)
    {
        _protocolBtn = [[UIButton alloc] init];
        [_protocolBtn setImage:[UIImage imageNamed:@"protocol"] forState:UIControlStateNormal];
        [_protocolBtn setTitle:@"注册协议" forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _protocolBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _protocolBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_protocolBtn addTarget:self action:@selector(didClickProtocolBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
}

-(UIImageView *)codeimg
{
    if(!_codeimg)
    {
        _codeimg = [[UIImageView alloc] init];
        _codeimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [_codeimg addGestureRecognizer:singleTap];
    }
    return _codeimg;
}

-(UITextField *)codetext
{
    if(!_codetext)
    {
        _codetext = [[UITextField alloc] init];
        _codetext.delegate = self;
        _codetext.placeholder = @"请输入图片验证码";
        _codetext.layer.borderColor = [UIColor hexStringToColor:@"999999"].CGColor; // set color as you want.
        _codetext.layer.borderWidth = 1.0; // set borderWidth as you want.
    }
    return _codetext;
}

-(void)handleSingleTap
{
    [self refreshimg];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

//获取uuid

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
