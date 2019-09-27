//
//  StaffModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject

@property (nonatomic, copy) NSString *companyJob;

@property (nonatomic,assign) NSInteger roleTypeId;

@property (nonatomic, copy) NSString *jobTypeName;

@property (nonatomic, copy) NSString *trueName;

@property (nonatomic, copy) NSString *agencySchool;

@property (nonatomic, copy) NSString *comment;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic,assign) NSInteger agencyId;

@end
