//
//  DayStatisticsViewController.h
//  iDecoration
//
//  Created by 丁 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface DayStatisticsViewController : SNViewController
typedef enum{
    DayStatisticsViewControllerTypeDay,
    DayStatisticsViewControllerTypeWeek,
    DayStatisticsViewControllerTypeMonth
}DayStatisticsViewControllerType;
@property (copy, nonatomic) NSString *companyId;
@property (assign, nonatomic) NSInteger type; // 0:当天,1:本周,2:本月
@property (copy, nonatomic) NSString *currentPerson;

@property (assign, nonatomic) DayStatisticsViewControllerType DayStatisticsViewControllerType;

@end
