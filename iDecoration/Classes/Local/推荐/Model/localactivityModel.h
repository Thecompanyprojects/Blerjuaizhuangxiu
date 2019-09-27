//
//  localactivityModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localactivityModel : NSObject
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger startTime;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, copy) NSString *designTitle;
@property (nonatomic, assign) NSInteger activityStatus;
@property (nonatomic, assign) NSInteger designId;
@property (nonatomic, strong) NSArray<NSString *> *imgs;
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, copy) NSString *coverMap;
@property (nonatomic, assign) NSInteger readNum;
@property (nonatomic, copy) NSString *designSubtitle;
@property (nonatomic, assign) NSInteger agencysId;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, assign) NSInteger musicPlay;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger activityPerson;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, copy) NSString *Newtemplate;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger personNum;
@end
