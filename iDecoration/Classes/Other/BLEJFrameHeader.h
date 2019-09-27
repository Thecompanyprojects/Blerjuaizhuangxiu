//
//  BLEJFrameHeader.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#ifndef BLEJFrameHeader_h
#define BLEJFrameHeader_h

//屏幕的物理宽度
#define     BLEJWidth            [UIScreen mainScreen].bounds.size.width
//屏幕的物理高度
#define     BLEJHeight           [UIScreen mainScreen].bounds.size.height
//当前设备的版本
#define     BLEJCurrentFloatDevice     [[[UIDevice currentDevice] systemVersion] floatValue]

// 屏幕宽高
#define kSCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define kSCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width

//屏幕宽度比
#define WIDTH_SCALE [UIScreen mainScreen].bounds.size.width / 375
//屏幕高度比
#define HEIGHT_SCALE [UIScreen mainScreen].bounds.size.height / 667

// iPhone4，5，6，6+判断
#define IPhone4 ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)
#define IPhone5 ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define IPhone6 ([UIScreen mainScreen].bounds.size.height == 667 ? YES : NO)
#define IPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736 ? YES : NO)
#define IphoneX ([UIScreen mainScreen].bounds.size.height == 812 ? YES : NO)

// 以iphone6为原型做屏幕适配大小
#define kSize(num) ([UIScreen mainScreen].bounds.size.width/375.0) * num
// 导航条底部y值
#define kNaviBottom self.navigationController.navigationBar.bottom
#define kNaviHeight (KIsiPhoneX?88:64)
#endif /* BLEJFrameHeader_h */
