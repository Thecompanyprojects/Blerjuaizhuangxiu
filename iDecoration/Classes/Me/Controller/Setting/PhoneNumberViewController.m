//
//  PhoneNumberViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "LoginViewController.h"
#import "ModifyPhoneApi.h"
#import "JudgeIsRegistedApi.h"
#import "VerifyIdentifyCodeApi.h"
#import "SendMessageApi.h"

@interface PhoneNumberViewController ()

@property (nonatomic, strong)IQKeyboardReturnKeyHandler *returnKeyHandler;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBtn;

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    
    self.title = @"修改手机号";
    self.view.backgroundColor = Bottom_Color;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

//验证码
- (IBAction)identify:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    
    if ([self.phoneNumberTF.text isEqualToString:user.phone]) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"与当前手机号码相同" controller:self sleep:1.5];

        return;
    }
    
    if (self.phoneNumberTF.text.length == 0) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的手机号码" controller:self sleep:1.5];
        
        return;
    }
    
    //    校验手机号码正则
    BOOL isCorrect = [[PublicTool defaultTool] publicToolsCheckTelNumber:self.phoneNumberTF.text];
    
    if (!isCorrect) {
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请输入正确的手机号码" controller:self sleep:1.5];
        
        return;
        
    }else{
    
        // 获取验证码按钮不可用  防止网络延迟多次点击
        sender.userInteractionEnabled = NO;
        NSString *phone = self.phoneNumberTF.text;
        
        JudgeIsRegistedApi *judgeApi = [[JudgeIsRegistedApi alloc]initWithPhoneNumber:phone];
        
        [judgeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
           
            // 你可以直接在这里使用 self
            NSDictionary *dic = request.responseJSONObject;
            if ([[dic objectForKey:@"code"] isEqualToString:@"1001"]) {
                // 恢复获取验证码可用
                 sender.userInteractionEnabled = YES;
                //                手机号为已注册号码
                [[PublicTool defaultTool] publicToolsHUDStr:@"该号码已经注册过" controller:self sleep:1.5];
                return ;
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]){
                //                手机号未注册
                [self sendMessageToPhone:self.phoneNumberTF.text smsType:@"1"];
            } else {
                 sender.userInteractionEnabled = YES;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            // 恢复获取验证码可用
            sender.userInteractionEnabled = YES;
            
        }];
    }
}

- (void)sendMessageToPhone:(NSString*)phone smsType:(NSString*)smsType {
    
    SendMessageApi *sendApi = [[SendMessageApi alloc]initWithPhoneNumber:phone smsType:smsType];
    
    [sendApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 恢复获取验证码可用
        self.checkCodeBtn.userInteractionEnabled = YES;
        NSDictionary *dic = request.responseJSONObject;
        
        if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]) {
            
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
                        [self.checkCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                        self.checkCodeBtn.userInteractionEnabled = YES;
                        self.checkCodeBtn.backgroundColor = kMainThemeColor;
                    });
                    
                } else {
                    
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
            
        }else if ([[dic objectForKey:@"code"] isEqualToString:@"1002"]){
            
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"今日短信次数已用完，请明日再试" controller:self];
            
            return ;
            
        } else {
            
            [[PublicTool defaultTool] publicToolsSureAlertInfo:@"验证码发送失败" controller:self];
            
            return ;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 恢复获取验证码可用
        self.checkCodeBtn.userInteractionEnabled = YES;
    }];
}

//确定
- (IBAction)sure:(id)sender {
    
    NSString *phone = self.phoneNumberTF.text;
    NSInteger idCode = [self.identifyTF.text integerValue];
    
    NSInteger agencyid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"alias"] integerValue];
    if (!agencyid||agencyid == 0) {
        agencyid = 0;
    }
    
    if (phone.length != 0 && self.identifyTF.text.length != 0) {
        
        VerifyIdentifyCodeApi *verifyApi = [[VerifyIdentifyCodeApi alloc]initWithPhoneNumber:phone code:self.identifyTF.text];
        
        [verifyApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
            
            switch (code) {
                case 1000:
                {
                    UserInfoModel *user = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
                    
                    ModifyPhoneApi *phoneApi = [[ModifyPhoneApi alloc]initWithPhone:phone agencyId:user.agencyId code:idCode];
                    
                    [phoneApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                        NSInteger code = [[request.responseJSONObject objectForKey:@"code"] integerValue];
                        
                        switch (code) {
                            case 1000:
                            {
                                user.phone = phone;
                                NSDictionary *dict = [user yy_modelToJSONObject];
                                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:AGENCYDICT];
                                
                                [[PublicTool defaultTool] publicToolsHUDStr:@"手机号码修改成功" controller:self sleep:1.5];
                                

                                LoginViewController *loginVC = [[LoginViewController alloc]init];
                                
                                [self.navigationController pushViewController:loginVC animated:YES];
                                
                            }
                                break;
                            case 1001:
                            {
                                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"手机号已绑定， 请选择其他手机号"];
                            }
                                break;
                            case 1002:
                            {
                                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码失效"];
                            }
                                break;
                            case 1003:
                            {
                                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"验证码不正确"];
                            }
                                break;
                            default:
                                break;
                        }
                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                    }];
                    
                    
                }
                    break;
                    
                case 1001:
                {
                    [[PublicTool defaultTool] publicToolsHUDStr:@"短信验证码错误" controller:self sleep:1.5];
                    
                    return ;
                }
                    break;
                    
                default:
                    break;
            }
            
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }else{
        
        [[PublicTool defaultTool] publicToolsHUDStr:@"请填写手机号和验证码" controller:self sleep:1.0];
        
        return;
    }
}

//销毁
- (void)dealloc
{
    self.returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
