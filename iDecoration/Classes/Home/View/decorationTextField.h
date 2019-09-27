//
//  decorationTextField.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/8/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol chooseDelegate <NSObject>


@end

@interface decorationTextField : UIView

@property(nonatomic,strong)UITextField *textField;
//右边的按钮
@property(nonatomic,strong)UIButton *rightButton;

@end
