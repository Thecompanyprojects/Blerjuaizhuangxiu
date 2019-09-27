//
//  PhoneAndIdentifyCodeView.m
//  iDecoration
//
//  Created by zuxi li on 2018/3/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "PhoneAndIdentifyCodeView.h"

@implementation PhoneAndIdentifyCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.layer.cornerRadius = 12;
    #warning 后台拖后腿 后续版本增加该功能 暂时注释
//    [GetImageVerificationCode setImageVerificationCodeToImageView:self.imageViewImageVerificationCode];
    self.getVertifyBtn.layer.cornerRadius = 4;
    self.getVertifyBtn.backgroundColor = kMainThemeColor;
    self.finishiBtn.layer.cornerRadius = 4;
}
- (IBAction)getVertifyAction:(id)sender {
    if (self.sendVertifyCodeBlock) {
        self.sendVertifyCodeBlock();
    }
}

- (IBAction)finishiAction:(id)sender {
    if (self.finishiBlock) {
        self.finishiBlock(self);
    }
}


@end
