//
//  NaText.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaText : UITextField
@property (nonatomic, copy) void(^valueChanged)(NSString *str);
@end
