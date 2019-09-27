//
//  Timestr.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "Timestr.h"

@implementation Timestr
//时间计算
+(NSString *)datetime:(NSString *)datestr
{
    
    long long  intdata = [datestr longLongValue]/1000;

    NSString *newDatestr = [NSString stringWithFormat:@"%lld",intdata];
    
    NSDate *newsDate = [NSDate dateWithTimeIntervalSince1970:[newDatestr intValue]];
    NSString *backstr = @"";

    NSDate *today=[[NSDate alloc] init];

    //日历
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:newsDate];

    NSDateComponents* comp4 = [calendar components:unitFlags fromDate:today];
    
    NSString*  format = @"YYYY-MM-dd HH:mm:ss";
    NSInteger timeinter = [newDatestr intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeinter];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSString *modeltimestr = confromTimespStr;
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:modeltimestr];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    
    if  (comp1.year == comp4.year && comp1.month == comp4.month && comp1.day == comp4.day) {
        if (hours<1&&minutes<30) {
             backstr = @"刚刚";
        }
        else if (hours<1&&minutes>=30)
        {
            backstr = @"30分钟前";
        }
        else if (hours>=1&&hours<24)
        {
            NSString *str = [NSString stringWithFormat:@"%d%@%@",hours,@"小时",@"前"];
            backstr = str;
        }
    }
    else if (comp1.year==comp4.year&&comp1.month==comp4.month) {
        NSString *str = [NSString stringWithFormat:@"%d%@%@",days+1,@"天",@"前"];
        backstr = str;
    }
    return backstr;
}

+(NSString *)newdatetime:(NSString *)datestr
{
    long long  intdata = [datestr longLongValue]/1000;
    
    NSString *newDatestr = [NSString stringWithFormat:@"%lld",intdata];
    
    //NSDate *newsDate = [NSDate dateWithTimeIntervalSince1970:[newDatestr intValue]];
    NSString *backstr = @"";
    
    //NSDate *today=[[NSDate alloc] init];
    
    //日历
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;

 
    NSString*  format = @"YYYY-MM-dd HH:mm:ss";
    NSInteger timeinter = [newDatestr intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeinter];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSString *modeltimestr = confromTimespStr;
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:modeltimestr];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minutes = ((int)time)%(3600*24)%3600/60;
    
    
    
    
   
        if (hours<1&&minutes<1) {
            backstr = @"刚刚";
        }
        else if (hours<1&&minutes>=1)
        {
            NSString *str = [NSString stringWithFormat:@"%d%@%@",minutes,@"分钟",@"前"];
            backstr = str;
        }
        else if (hours>=1&&hours<=24)
        {
            NSString *str = [NSString stringWithFormat:@"%d%@%@",hours,@"小时",@"前"];
            backstr = str;
        }
        else
        {
            NSString *str = [NSString stringWithFormat:@"%d%@%@",days,@"天",@"前"];
            backstr = str;
        }

    return backstr;
}

+(NSInteger )creatdatetime:(NSString  *)newdate
{
//    NSString *datestr = [NSString stringWithFormat:@"%f",newdate];
//    long long  intdata = [datestr longLongValue]/1000;
//    NSString *newDatestr = [NSString stringWithFormat:@"%lld",intdata];
//
//    NSString*  format = @"YYYY-MM-dd HH:mm:ss";
//    NSInteger timeinter = [newDatestr intValue];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:format];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
//    [formatter setTimeZone:timeZone];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeinter];
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//    NSString *modeltimestr = confromTimespStr;
//    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//
//
    //然后创建日期对象
    
    NSString *newstrds = [NSString stringWithFormat:@"%@",newdate];
    NSDate *date1 = [dateFormatter dateFromString:newstrds];
    NSDate *date = [NSDate date];
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date1 timeIntervalSinceDate:date];
    //计算天数、时、分、秒
    
    int days = ((int)time)/(3600*24);
    NSInteger returnintger = (long)days;
    return returnintger;
}

@end
