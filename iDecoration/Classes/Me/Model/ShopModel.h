//
//  ShopModel.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countyId;

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *countyName;

@property (nonatomic, copy) NSString *companyTotal;
@property (nonatomic, copy) NSString *createPersonId;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *merchantLogo;
@property (nonatomic, copy) NSString *merchantName;
@property (nonatomic, copy) NSString *merchantPhone;
@property (nonatomic, copy) NSString *merchantWx;
@property (nonatomic, copy) NSString *relId;
@property (nonatomic, copy) NSString *relType;
@property (nonatomic, copy) NSString *seeFlag;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeNo;
@property (nonatomic, copy) NSString *vipDay;
@property (nonatomic, copy) NSString *vipState;
@property (nonatomic, copy) NSString *createDatetime;

@end
