//
//  ResetPasswordViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/3/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "LoginViewController.h"
#import "SNViewController.h"
#import "ResetPwdApi.h"

@interface ResetPasswordViewController ()

//@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTopToSuperViewCon;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    
    self.title = @"输入新密码";
    self.view.backgroundColor = Bottom_Color;
    self.passwordTopToSuperViewCon.constant = self.navigationController.navigationBar.bottom + 10;
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tui2"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtn:)];
    leftBtn.tintColor = White_Color;
    self.navigationItem.leftBarButtonItem = leftBtn;
}

//返回按钮
- (void)backBtn:(UIBarButtonItem*)sender {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureClick:(id)sender {
    
    NSString *password = self.latestPasswordTF.text;
    NSString *strPassword = [password stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strPassword.length < 6 || strPassword.length > 16) {
        [[PublicTool defaultTool] publicToolsHUDStr:@"请勿输入非法字符，密码长度在6-16之间" controller:self sleep:1.5];
        return;
    }
    
        [self resetPassword];
}

- (void)resetPassword {
    
    if ([self.latestPasswordTF.text isEqualToString:self.RepeatPasswordTF.text]) {
        
        ResetPwdApi *resetApi = [[ResetPwdApi alloc]initWithPhoneNumber:self.phone code:self.code newPwd:self.RepeatPasswordTF.text];
        
        [resetApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            NSDictionary *dic = request.responseJSONObject;
            
            if ([[dic objectForKey:@"code"] isEqualToString:@"1000"]) {
                
                
                [self.navigationController popToViewController:self.navigationController.childViewControllers[1] animated:YES];
                [[PublicTool defaultTool] publicToolsHUDStr:@"密码重置成功!" controller:self sleep:1.0];

                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1001"]){
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"短信验证码失效！" controller:self sleep:1.0];
                
                return;
                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1002"]){
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"短信验证码错误！" controller:self sleep:1.0];
                
                return;
                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"1004"]){
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"手机号码有误！" controller:self sleep:1.0];
                
                return;
                
            }else if ([[dic objectForKey:@"code"] isEqualToString:@"2000"]){
                
                [[PublicTool defaultTool] publicToolsHUDStr:@"密码修改失败！" controller:self sleep:1.0];
                
                return;
            }
            
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            YSNLog(@"%@",request);
        }];
        
    }else{
        
        [[PublicTool defaultTool] publicToolsSureAlertInfo:@"两次密码输入不一致，请重新输入！" controller:self];
        
        return;
    }
}

- (void)dealloc {
    
//    self.returnKeyHandler = nil;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
