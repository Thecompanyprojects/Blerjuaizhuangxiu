//
//  LocationViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/9/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface LocationViewController : SNViewController
@property (nonatomic, copy) NSString *address; // 店铺地址 有值为编辑  2 无值创建
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) void(^locationBlock)(NSString *addressName, double lantitude, double longitude);
- (NSString *)getAddress;
@end
