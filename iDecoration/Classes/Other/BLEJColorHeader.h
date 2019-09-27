//
//  BLEJColorHeader.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#ifndef BLEJColorHeader_h
#define BLEJColorHeader_h

// 三个参数是一样的
#define     kCOLOR(a)                             [UIColor colorWithRed:a/255.0f green:a/255.0f blue:a/255.0f alpha:1.0f]
// 自定义三个参数
#define     kCustomColor(r,g,b)                   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
// 自定义三个参数和透明度
#define     kCustomColorAndAlpha(r,g,b,a)         [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


// 传入一个6位数的颜色值和透明度(c: 0x000000)
#define    kColorRGBA(c,a)                        [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:a]
// 只需要传入一个6位数的颜色值(c: 0x000000)
#define    kColorRGB(c)                           [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]


// 随机色
#define    kRandomColor                           [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0]

// 主题色
#define kMainThemeColor                           kColorRGB(0x25b764)
// 背景色
#define kBackgroundColor                          kColorRGB(0xf0f0f0)
// 分割线
#define kSepLineColor                             kColorRGB(0xdfdfdd)
// 拨打电话的按钮颜色
#define kCallPhoneColor                           kColorRGB(0x66cc99)
// 发短信的按钮颜色
#define kSendShortMesColor                        kColorRGB(0x66cccc)
// 顾客不可联系按钮颜色(失效)
#define kDisabledColor                            kColorRGB(0xcccccc)
// 灰色字体颜色
#define kGrayTextColor                            kColorRGB(0x999999)
// 占位字符颜色
#define kPlaceHolderTextColor                     kCOLOR(200)
//是否是iphonex
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - COLOR

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue, _alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:_alpha]
#define HEX_COLOR(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]

// 随机色
#define UIRandomColor RGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 常用颜色
#define Main_Color     [UIColor colorWithRed:29.0/255.0 green:181.0/255.0 blue:112.0/255.0 alpha:1.0]
#define White_Color    [UIColor whiteColor]
#define Clear_Color    [UIColor clearColor]
#define Black_Color    [UIColor blackColor]
#define Red_Color      [UIColor redColor]
#define Green_Color      [UIColor greenColor]
#define Yellow_Color   [UIColor yellowColor]
#define Blue_Color   [UIColor blueColor]
#define Gray_Color   [UIColor grayColor]
#define Purple_Color   [UIColor purpleColor]

#define Bottom_Color     [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]
#define COLOR_BLACK_CLASS_3     HEX_COLOR(0x333333)
#define COLOR_BLACK_CLASS_5     HEX_COLOR(0x555555)
#define COLOR_BLACK_CLASS_6    HEX_COLOR(0x666666)
#define COLOR_BLACK_CLASS_9      HEX_COLOR(0x999999)
#define COLOR_BLACK_CLASS_0      HEX_COLOR(0xd2d2d2)
//主题色
#define basicColor kColorRGB(0x25b764)


#define COLOR_BLACK_CLASS_H     HEX_COLOR(0x333333)
#define COLOR_BLACK_CLASS_M    HEX_COLOR(0x666666)
#define COLOR_BLACK_CLASS_L      HEX_COLOR(0x999999)

#define COLOR_BLACK_CLASS_Y      HEX_COLOR(0xFECC36)
#define COLOR_BLACK_CLASS_O      HEX_COLOR(0xD80D18)
#endif /* BLEJColorHeader_h */
