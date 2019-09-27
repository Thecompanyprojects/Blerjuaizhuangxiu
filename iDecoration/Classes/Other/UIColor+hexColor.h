//
//  UIColor+hexColor.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexColor)
/**
 将16进制颜色转换成color
 @param stringToConvert #ffffff
 @return 返回颜色
 */
+(UIColor *)hexStringToColor: (NSString *) stringToConvert;
@end
