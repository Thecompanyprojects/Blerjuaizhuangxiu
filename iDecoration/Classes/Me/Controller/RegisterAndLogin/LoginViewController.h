//
//  LoginViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/2/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"


@interface LoginViewController : SNViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *AccountTF;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *ForgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;


//判断登陆的跳转方式
@property(nonatomic,assign)NSInteger  tag;
@end
