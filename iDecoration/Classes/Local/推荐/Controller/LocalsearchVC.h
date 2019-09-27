//
//  LocalsearchVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/25.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface LocalsearchVC : SNViewController
@property (nonatomic,copy) NSString *lng;//经度
@property (nonatomic,copy) NSString *lat;//纬度
@property (nonatomic,copy) NSString *cityId;//城市id
@property (nonatomic,copy) NSString *countyId;//区县id
@end
