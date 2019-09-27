//
//  ForgetPasswordViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "VerifyIdentifyCodeApi.h"
#import "JudgeIsRegistedApi.h"
#import "SendMessageApi.h"

@interface ForgetPasswordViewController ()

//@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *textFieldImageVerificationCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImageVerificationCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLabelTopSuperViewCon;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    self.title = @"找回密码";
    self.view.backgroundColor = Bottom_Color;
    if (IphoneX) {
        self.phoneLabelTopSuperViewCon.constant = 88 + 10;
    } else {
        self.phoneLabelTopSuperViewCon.constant = 64 + 10;
    }
    #warning 后台拖后腿 后续版本增加该功能 暂时注释
    [GetImageVerificationCode setImageVerificationCodeToImageView:self.imageViewImageVerificationCode];
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tui2"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtn:)];
    leftBtn.tintColor = White_Color;
    self.navigationItem.leftBarButtonItem = leftBtn;
    
}

//返回按钮
- (void)backBtn:(UIBarButtonItem*)sender{
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//下一步
- (IBAction)nextClick:(id)sender {
    
    [self resetPwd];
  
}

- (void)resetPwd {
    
    [self.view endEditing:YES];
    if (self.textFieldImageVerificationCode.text.length == 0) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入图形验证码" controller:self sleep:1.0];
        return;
    }
    NSString *phone = self.phoneTF.text;
    NSString *code = self.identfiyTF.text;
    NSString *imageVerificationCode = self.textFieldImageVerificationCode.text;
    if (phone.length != 0 && code.length != 0) {
        
        VerifyIdentifyCodeApi *verifyApi = [[VerifyIdentifyCodeApi alloc]initWithPhoneNumber:phone code:code];
        
        [verifyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSDictionary *dic = request.responseJSONObject;
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]) {
                
                ResetPasswordViewController *resetVC = [[ResetPasswordViewController alloc]init];
                resetVC.phone = phone;
                resetVC.code = code;
                [self.navigationController pushViewController:resetVC animated:YES];
                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1001"]){
                
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"短信验证码错误" controller:self];
                
                return ;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }else{
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写手机号和验证码" controller:self sleep:1.0];
        
        return;
    }
    
}
//验证码
- (IBAction)identify:(id)sender {
    
    [self.view endEditing:YES];
    if (self.phoneTF.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的手机号码" controller:self sleep:1.0];
        
        return;
    }
    
    //    校验手机号码正则
    BOOL isCorrect = [[PublicTool defaultTool] publicToolsCheckTelNumber:self.phoneTF.text];
    
    if (!isCorrect) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的手机号码" controller:self sleep:1.0];
        
        return;
        
    }else{
        
        NSString *phone = self.phoneTF.text;
        
        JudgeIsRegistedApi *judgeApi = [[JudgeIsRegistedApi alloc]initWithPhoneNumber:phone];
        
        [judgeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            // 你可以直接在这里使用 self
            NSDictionary *dic = request.responseJSONObject;
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"1001"]) {
                
//                手机号为已注册号码
                [self sendMessageToPhone:self.phoneTF.text smsType:@"1"];
                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]){
//                手机号未注册
                [[PublicTool defaultTool] publicToolsSureAlertInfo:@"该号码未注册过，请检查该号码是否正确" controller:self];
                
                return ;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            // 你可以直接在这里使用 self
            
        }];
    }

}

- (void)sendMessageToPhone:(NSString*)phone smsType:(NSString*)smsType {
    if (!self.textFieldImageVerificationCode.text.length) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入图形验证码" controller:self sleep:1.0];
    }
    NSString *URL = @"sms/smsCode.do";
    NSMutableDictionary *parameters = @{}.mutableCopy;
    parameters[@"phone"] = phone;
    parameters[@"code"] = self.textFieldImageVerificationCode.text;
    parameters[@"v"] = GetImageVerificationCode.UUIDString;
    [NetWorkRequest postJSONWithUrl:URL parameters:parameters success:^(id result) {
        NSLog(@"%@",result);
        NSDictionary *dic = result;
        if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]) {
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码发送成功" controller:self];
            __block int timeout = 120; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout <= 0) { //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        [self.checkCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.checkCodeBtn.userInteractionEnabled = YES;
                        self.checkCodeBtn.backgroundColor = kMainThemeColor;
                    });
                }else{
                    int seconds = timeout;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //设置界面的按钮显示 根据自己需求设置
                        //NSLog(@"____%@",strTime);
                        [UIView beginAnimations:nil context:nil];
                        [UIView setAnimationDuration:1];
                        [self.checkCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                        [UIView commitAnimations];
                        self.checkCodeBtn.userInteractionEnabled = NO;
                        self.checkCodeBtn.backgroundColor = kDisabledColor;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            return ;
        }else if ([[dic objectForKey:@"code"] isEqualToString:@"1002"]) {
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"今日短信次数已用完，请明日再试" controller:self];
            return ;
        }else{
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码发送失败" controller:self];
            return;
        }
    } fail:^(NSError *error) {

    }];
}

- (void)dealloc {
    
//    self.returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
