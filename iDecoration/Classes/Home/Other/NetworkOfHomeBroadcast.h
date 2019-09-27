//
//  NetworkOfHomeBroadcast.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/8.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,ListMode){
    ListModeCompany = 0,
    ListModeEmployee = 1
};

@interface NetworkOfHomeBroadcast : NSObject

/**
 是否是企业播报
 */
@property (assign, nonatomic) BOOL isCompany;

/**
 类型（0:在线预约,1:计算器,2:活动线下,4:线上活动）
 */
@property (assign, nonatomic) NSInteger type;

/**
 当日接单数
 */
@property (strong, nonatomic) NSString *todayCounts;

/**
 昨日接单数
 */
@property (strong, nonatomic) NSString *yesterDayCounts;
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) NSString *text;

/**
 
 */
@property (strong, nonatomic) NSString *trueName;
/**
 表情符
 */
@property (copy, nonatomic) NSString *expression;
@property (copy, nonatomic) NSString *title;

/**
 接单时间
 */
@property (copy, nonatomic) NSString *createDate;
@property (copy, nonatomic) NSString *createDateStr;
@property (strong, nonatomic) NSArray *arrayData;
@property (strong, nonatomic) NSArray *arrayImageName;
@property (strong, nonatomic) NSArray *phoneList;
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSMutableArray *arrayString;
@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) ListMode listMode;

+ (instancetype)sharedInstance;
- (void)NetworkOfListType:(ListMode)listmode AndPage:(NSNumber *)page AndSuccess:(void(^)(void))success AndFailed:(void(^)(void))failed;
@end

NS_ASSUME_NONNULL_END
