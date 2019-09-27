//
//  ZCHBottomLocationPickerView.h
//  iDecoration
//
//  Created by 赵春浩 on 17/8/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBtnBlock)(NSDictionary *dic);
typedef void(^LocationBtnBlock)();
@interface ZCHBottomLocationPickerView : UIView

@property (copy, nonatomic) ConfirmBtnBlock confirmBlock;
@property (copy, nonatomic) LocationBtnBlock locationBlock;

@end
