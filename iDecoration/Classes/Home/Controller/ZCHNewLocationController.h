//
//  ZCHNewLocationController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^RefreshBlock)(NSDictionary *modelDic);

@interface ZCHNewLocationController : SNViewController

//// 经度
//@property (copy, nonatomic) NSString *longitude;
//// 纬度
//@property (copy, nonatomic) NSString *latitude;
// 城市id
//@property (copy, nonatomic) NSString *cityId;
// 区县id
//@property (copy, nonatomic) NSString *ereaId;

@property (copy, nonatomic) RefreshBlock refreshBlock;

@end
