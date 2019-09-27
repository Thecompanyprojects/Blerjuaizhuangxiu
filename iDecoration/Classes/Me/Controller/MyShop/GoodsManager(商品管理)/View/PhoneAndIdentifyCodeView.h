//
//  PhoneAndIdentifyCodeView.h
//  iDecoration
//
//  Created by zuxi li on 2018/3/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneAndIdentifyCodeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImageVerificationCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldImageVerificationCode;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *vertifyTF;
@property (weak, nonatomic) IBOutlet UIButton *getVertifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishiBtn;

@property (nonatomic, copy) void (^sendVertifyCodeBlock)();
@property (nonatomic, copy) void (^finishiBlock)(PhoneAndIdentifyCodeView *pView);

@end
