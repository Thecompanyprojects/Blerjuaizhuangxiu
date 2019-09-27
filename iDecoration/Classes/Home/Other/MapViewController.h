//
//  MapViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/9/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@interface MapViewController : SNViewController
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyAddress;  // 地址格式为 北京市北京市昌平区 详细地址哦哦哦哦
@end
