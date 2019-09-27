//
//  NSDate+Time.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)

/**
 从时间戳获取档期时间 年.月.日
 
 @param timeInterval 时间戳
 @return 字符串
 */
+ (NSString *)yearMoneyDayFromTimeInterval:(NSTimeInterval)timeInterval;
/**
 从时间戳获取档期时间 xxxx年xx月xx日
 
 @param timeInterval 时间戳
 @return 字符串
 */
+ (NSString *)yearMoneyDayWithChineseFromTimeInterval:(NSTimeInterval)timeInterval;


/**
 从时间戳获取档期时间 年-月-日 10:00
 
 @param timeInterval 时间戳
 @return 字符串
 */
+ (NSString *)yearMoneyDayAndHourMinuteFromTimeInterval:(NSTimeInterval)timeInterval;
/**
 获取当前日期年月日  二零一八年二月四日

 @return 当前日期
 */
+ (NSString*)curentYearMonthDay;

/**
 获取timeInterval 的日期年月日  二零一八年二月四日

 @param timeInterval 时间戳毫秒级
 @return 获取timeInterval 的日期年月日  二零一八年二月四日
 */
+ (NSString *)YearMonthDayWithTimeInterval:(NSTimeInterval)timeInterval;
@end
