//
//  SignUpManageListModel.h
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CusList;


@interface SignUpManageListModel : NSObject

@property (nonatomic, strong) NSArray<CusList *> *custList;
@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, copy) NSString *phoneCode;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, assign) NSInteger vipFlag;
@property (nonatomic, assign) NSInteger activityId;
@property (nonatomic, copy) NSString *designTitle;
@property (nonatomic, assign) NSInteger calVip;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, assign) NSInteger agencysId;
@property (nonatomic, assign) NSInteger topFlag;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *userPhone;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *signUpTime;
@property (nonatomic, assign) NSInteger agencysJob;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger signUpId;

@end


@interface CusList : NSObject

@end
