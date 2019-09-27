//
//  UnionActivitySettingController.h
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ActivityType) {
    ActivityTypeCompany, // 公司活动
    ActivityTypeUnion, // 联盟活动
    ActivityTypePersonal, // 个人活动
};
#import "SNViewController.h"

@interface UnionActivitySettingController : SNViewController
@property (nonatomic, copy) void (^dictBlock)(NSMutableDictionary *dict);
@property (nonatomic, strong) NSMutableArray *setDataArray;

@property (nonatomic, copy) NSString *activyty;//活动id

@property (nonatomic, copy) NSString *actStartTimeStr;//活动开始时间
@property (nonatomic, copy) NSString *actEndTimeStr;//活动结束时间
@property (nonatomic, copy) NSString *signUpNumStr;//活动总人数 0：不限制

@property (nonatomic, copy) NSString *activityPlace;//0:线下，1：线上
@property (nonatomic, copy) NSString *activityAddress;//活动地址
@property (nonatomic, copy) NSString *activityEnd;//0:活动结束之前截止报名，1：活动开始前截止报名

@property (nonatomic, copy) NSString *cost; // 活动费用
@property (nonatomic, copy) NSString *costName; // 费用名称

@property (nonatomic, assign) double lantitude; // 地址经纬度
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) BOOL isFistr;//是否是第一次添加

@property (nonatomic, assign) ActivityType activityType;
@property (nonatomic, assign) NSInteger companyID;
@end
