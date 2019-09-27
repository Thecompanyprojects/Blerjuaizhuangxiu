//
//  SpecialAlertView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBlock)(NSString *string);

@interface SpecialAlertView : UIView

-(instancetype) initWithTime:(NSString *)timestr messageTitle:(NSString *)titleStr messageString:(NSString *)contentStr sureBtnTitle:(NSString *)titleString sureBtnColor:(UIColor *)BtnColor;

@property(nonatomic,copy)sureBlock sureClick;

-(void)withSureClick:(sureBlock)block;

@end
