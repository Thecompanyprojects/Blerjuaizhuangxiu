//
//  YellowPageActivityCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YellowPageActivityCell.h"

@implementation YellowPageActivityCell


-(void)awakeFromNib{
    
    [super awakeFromNib];
    

    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(changeHeight:) name:@"KCellHeightChange"  object:nil];
 
     
    self.topImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.topImageView.layer.masksToBounds = YES;
    
    self.nameTF.layer.borderColor=[UIColor grayColor].CGColor;
    self.phoneNumTF.layer.borderColor=[UIColor grayColor].CGColor;
    self.vertifyCodeTF.layer.borderColor=[UIColor grayColor].CGColor;

    self.phoneNumTF.layer.borderWidth=0.7;    self.nameTF.layer.borderWidth=0.7;
    self.vertifyCodeTF.layer.borderWidth=0.7;
   
   // 发送验证码
  //  self.sendCodeButton.layer.borderColor=kMainThemeColor.CGColor;
   // self.sendCodeButton.layer.borderWidth=.8; self.sendCodeButton.layer.cornerRadius=CGRectGetWidth(self.sendCodeButton.frame)*0.1;
    
    /*立即报名*/

    self.signUpButton.layer.masksToBounds = YES;
    self.signUpButton.backgroundColor=kMainThemeColor;
    /*活动详情*/
    self.activityDetailButton.backgroundColor = kMainThemeColor;
    self.activityDetailButton.layer.masksToBounds = YES;
    self.activityDetailButton.backgroundColor=kMainThemeColor;

    [self.textFieldImageVerificationCode addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
}
-(void)changeHeight:(NSNotification *)noti{

     NSLog(@"收到消息啦!!!");


    self.dynamicView = [noti.userInfo objectForKey:@"height"];

    NSLog(@"%@",self.dynamicView);
    self.dynamicHeightconstant.constant= self.dynamicView.frame.size.height;



}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)textFieldTextDidChanged:(UITextField *)textField {
    if (self.block) {
        self.block(textField.text);
    }
}

- (IBAction)sendCodeAction:(id)sender {
    if (self.getVeitifyCodeBlock) {
        self.getVeitifyCodeBlock(self);
    }
}
- (IBAction)signUpAction:(id)sender {
    if (self.signUpNowBlock) {
        self.signUpNowBlock(self);
    }
}
- (IBAction)activityDetailAction:(id)sender {
    if (self.activityDetailBlock) {
        self.activityDetailBlock(self);
    }
}


-(CGFloat)cellHeightExceptImageHeightAndNotNecessaryTFFrame{

   CGFloat height = 71*3+(30+16)*2 +16*2+20;
    return height;
}


@end
