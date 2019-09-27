//
//  SpreadNewsList.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpreadNewsList : NSObject
@property (nonatomic, assign) NSInteger city;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, assign) NSInteger province;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *incomeId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger incomeType;

@end
