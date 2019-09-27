//
//  DataStatisticsModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStatisticsModel : NSObject
@property (strong, nonatomic, class, readonly) NSArray *arrayTop;
@property (strong, nonatomic, class, readonly) NSArray *arrayTitle;

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *valuelist;
@property (strong, nonatomic) NSArray *valueList;
@property (strong, nonatomic) NSArray *list;
@property (copy, nonatomic) NSString *titleName;
@property (copy, nonatomic) NSString *maxValue;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *xName;
@property (copy, nonatomic) NSString *xValue;

@end
