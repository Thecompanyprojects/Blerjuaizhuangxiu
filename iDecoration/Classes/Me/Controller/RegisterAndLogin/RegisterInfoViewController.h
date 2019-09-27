//
//  RegisterInfoViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface RegisterInfoViewController : SNViewController

@property (nonatomic, copy)NSString *phone;

@property (nonatomic, copy)NSString *inviteCode;//分销员邀请码

@property (nonatomic, copy)NSString *phoneCode;//手机验证码
@end
