//
//  ResetPasswordViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/3/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ResetPasswordViewController : SNViewController

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *code;
@property (weak, nonatomic) IBOutlet UITextField *latestPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *RepeatPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
