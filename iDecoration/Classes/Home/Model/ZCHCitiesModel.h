//
//  ZCHCitiesModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZCHCityModel;

@interface ZCHCitiesModel : NSObject

/**
 *  首字母
 */
@property (copy, nonatomic) NSString *firstChar;
/**
 *  城市数组
 */
@property (strong, nonatomic) NSArray <ZCHCityModel *>*citys;

@end
