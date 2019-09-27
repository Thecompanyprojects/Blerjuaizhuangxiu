//
//  ZCHCityModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHCityModel : NSObject<NSCoding>

/**
 *  城市id
 */
@property (copy, nonatomic) NSString *cityId;
/**
 *
 */
@property (copy, nonatomic) NSString *pid;
/**
 *  城市名字
 */
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *provinceId;
@property (copy, nonatomic) NSString *countyId;


@end
