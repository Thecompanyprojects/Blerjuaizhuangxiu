//
//  localnotesModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localnotesModel : NSObject
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, copy) NSString *designTitle;
@property (nonatomic, assign) NSInteger designId;
@property (nonatomic, strong) NSArray<NSString *> *imgs;
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, copy) NSString *coverMap;
@property (nonatomic, assign) NSInteger giftCouponId;
@property (nonatomic, assign) NSInteger readNum;
@property (nonatomic, copy) NSString *designSubtitle;
@property (nonatomic, assign) NSInteger agencysId;
@property (nonatomic, assign) NSInteger messageCount;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, assign) NSInteger musicPlay;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *Newtemplate;
@property (nonatomic, assign) NSInteger couponId;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, assign) BOOL iszan;
@end
