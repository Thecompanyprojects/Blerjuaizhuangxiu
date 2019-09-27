//
//  decorationTextField.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/8/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "decorationTextField.h"

@implementation decorationTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}



-(void)setUpView{

    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, self.width - 20, self.height - 10)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.font = NB_FONTSEIZ_NOR;
    [self addSubview:self.textField];

    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, CGRectGetHeight(self.textField.frame))];
    [self.rightButton setImage:[UIImage imageNamed:@"trigon"] forState:UIControlStateNormal];
    self.textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.textField.frame) - 30, 0, 30, CGRectGetHeight(self.textField.frame))];
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    [self.textField.rightView  addSubview:self.rightButton] ;
    
    

}

@end
