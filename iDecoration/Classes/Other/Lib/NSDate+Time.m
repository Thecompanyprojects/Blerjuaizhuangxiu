//
//  NSDate+Time.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)

+ (NSString *)yearMoneyDayFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return dateString;
}

+ (NSString *)yearMoneyDayWithChineseFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return dateString;
}

+ (NSString *)yearMoneyDayAndHourMinuteFromTimeInterval:(NSTimeInterval)timeInterval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    return dateString;
}

+ (NSString *)curentYearMonthDay {
    // 设置时间格式
    NSDate  *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    
    return [NSString stringWithFormat:@"%@年%@月%@日", [self yearMonthDayToChinese:year isYear:YES], [self yearMonthDayToChinese:month isYear:NO], [self yearMonthDayToChinese:day isYear:NO]];

}

+ (NSString *)YearMonthDayWithTimeInterval:(NSTimeInterval)timeInterval {
    NSDate  *currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSInteger year=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    
    return [NSString stringWithFormat:@"%@年%@月%@日", [self yearMonthDayToChinese:year isYear:YES], [self yearMonthDayToChinese:month isYear:NO], [self yearMonthDayToChinese:day isYear:NO]];
}

+ (NSString *)yearMonthDayToChinese:(NSInteger)x isYear:(BOOL)isYear {
    NSInteger i = x;
    NSArray *array = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    NSMutableArray *numArray = [NSMutableArray array];
    NSMutableString *mulStr = [NSMutableString string];
    if (isYear) {
        while (i > 0) {
            NSInteger n = i % 10;
            [numArray addObject:array[n]];
            i = i / 10;
        }
        for (NSInteger j = numArray.count - 1; j >= 0; j --) {
            [mulStr appendString:numArray[j]];
        }
        return [mulStr copy];
        
    } else {
        if (i <= 9) {
            return array[i];
        } else {
            NSInteger n = i % 10; // 余数
            NSInteger m = i / 10; // 整数
            if (m == 1) {
                [mulStr appendString:@"十"];
            } else {
                [mulStr appendString:array[m]];
                [mulStr appendString:@"十"];
            }
            if (n != 0) {
                [mulStr appendString:array[n]];
            }
            return [mulStr copy];
        }
    }
    return @"";
}

@end
