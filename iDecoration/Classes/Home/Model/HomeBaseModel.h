//
//  HomeBaseModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/8/6.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBaseModel : NSObject
@property (copy, nonatomic) NSString *companyIntroduction;//公司简介
@property (copy, nonatomic) NSString *locationStr;
@property (copy, nonatomic) NSString *companyAddress;
@property (copy, nonatomic) NSString *distance;//距离
@property (copy, nonatomic) NSString *flower;//好评 显示鲜花数
@property (copy, nonatomic) NSString *banner;//信用显示锦旗数
@property (copy, nonatomic) NSString *browse;//浏览量
@property (copy, nonatomic) NSString *caseTotla;//案例量
@property (copy, nonatomic) NSString *praiseTotal;//商品数量
@property (copy, nonatomic) NSString *countyName;
@property (copy, nonatomic) NSString *total;
//address
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *displayNumbers;
@property (copy, nonatomic) NSString *companyLandline;
@property (copy, nonatomic) NSString *region;
@property (copy, nonatomic) NSString *companyLogo;
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *svipEnd;

@end

NS_ASSUME_NONNULL_END
