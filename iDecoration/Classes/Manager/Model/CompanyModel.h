//
//  CompanyModel.h
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyModel : NSObject

@property (nonatomic, assign) NSInteger createPerson;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyNumber;
@property (nonatomic, copy) NSString *companySlogan;
@property (nonatomic, copy) NSString *headQuarters;//是否是总公司
//@property (nonatomic, strong) NSArray *areaList;//数组转为json
@property (nonatomic, copy) NSString *areaList;
@property (nonatomic, copy) NSString *pid;//上级公司id,null则为创建的总公司
@property (nonatomic, copy) NSString *vipStartTime;//公司会员vip开始时间
@property (nonatomic, copy) NSString *vipEndTime;//司会员vip结束时间
@property (nonatomic, copy) NSString *createTime;//创建时间，时间戳)
@property (nonatomic, copy) NSString *myJobType;
@property (nonatomic, copy) NSString *agencysId;
@property (nonatomic, copy) NSString *myCompanyId;

@end
