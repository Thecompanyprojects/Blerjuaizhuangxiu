//
//  DateStatisticsModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/11/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateStatisticsModel : NSObject

/**
 公司名称
 */
@property (nonatomic, copy) NSString *companyName;

/**
 公司类型
 */
@property (nonatomic, copy) NSString *companyType;

/**
 是否是总公司
 */
@property (nonatomic, assign) NSInteger headQuarters;
/**
 企业总分享量
 */
@property (nonatomic, assign) NSUInteger shareNumbers;

/**
企业今日分享量
 */
@property (nonatomic, assign) NSUInteger todayShare;

/**
 企业总收藏量
 */
@property (nonatomic, assign) NSUInteger collectionNumbers;

/**
企业今日收藏量
 */
@property (nonatomic, assign) NSUInteger todayColloction;

/**
 企业总浏览量
 */
@property (nonatomic, assign) NSUInteger browse;

/**
企业今日浏览量
 */
@property (nonatomic, assign) NSUInteger todayBrowse;

/**
 企业总展现量
 */
@property (nonatomic, assign) NSUInteger displayNumbers;

/**
 企业今日展现量
 */
@property (nonatomic, assign) NSUInteger todayDisplay;

/**
 投诉量
 */
@property (nonatomic, assign) NSUInteger cscCounts;

/**
 工地总浏览量
 */
@property (nonatomic, assign) NSUInteger cconScanCount;

/**
 工地今日浏览量
 */
@property (nonatomic, assign) NSUInteger cconTodayScan;

/**
 工地总分享量
 */
@property (nonatomic, assign) NSUInteger cconShareNumbers;

/**
 工地今日分享量
 */
@property (nonatomic, assign) NSUInteger cconTodayShare;

/**
 工地总点赞量
 */
@property (nonatomic, assign) NSUInteger cconLikeNumbers;

/**
 工地今日点赞量
 */
@property (nonatomic, assign) NSUInteger cconTodayLike;

/**
工地总展现量
 */
@property (nonatomic, assign) NSUInteger cconDisplayNumbers;

/**
工地今日展现量
 */
@property (nonatomic, assign) NSUInteger cconTodayDisplay;

/**
计算总器浏览量
 */
@property (nonatomic, assign) NSUInteger ccbtBrowse;

/**
计算器今日浏览量
 */
@property (nonatomic, assign) NSUInteger ccbtTodayBrowse;

/**
计算器总计算量
 */
@property (nonatomic, assign) NSUInteger ccbtCalTimes;

/**
 计算器今日计算量
 */
@property (nonatomic, assign) NSUInteger ccbtTodayCal;

/**
计算器总手机号
 */
@property (nonatomic, assign) NSUInteger totalCustomer;

/**
计算器今日手机号
 */
@property (nonatomic, assign) NSUInteger todayCustomer;

/**
喊装修总浏览量
 */
@property (nonatomic, assign) NSUInteger callBrowse;

/**
喊装修今日浏览量
 */
@property (nonatomic, assign) NSUInteger todayCallBrowse;

/**
喊装修客户总数
 */
@property (nonatomic, assign) NSUInteger totalCallDecor;

/**
喊装修今日客户数
 */
@property (nonatomic, assign) NSUInteger todayCallDecor;

/**
商品总浏览量
 */
@property (nonatomic, assign) NSUInteger cmBrowse;

/**
商品今日浏览量
 */
@property (nonatomic, assign) NSUInteger cmTodayBrowse;

/**
 企业总分享量
 */
@property (nonatomic, assign) NSUInteger cmShareNumbers;

/**
商品今日分享量
 */
@property (nonatomic, assign) NSUInteger cmTodayShare;

/**
商品总展现量
 */
@property (nonatomic, assign) NSUInteger cmDisplayNumbers;

/**
商品今日展现量
 */
@property (nonatomic, assign) NSUInteger cmTodayDisplay;




@end
