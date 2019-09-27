//
//  ConstructionMemberModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstructionMemberModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *cpConstructionId;
@property (nonatomic, copy) NSString *cJobTypeId;
@property (nonatomic, copy) NSString *rongUserId;
@property (nonatomic, copy) NSString *cpLimitsId;//职位id
@property (nonatomic, copy) NSString *cpPersonId;
@property (nonatomic, copy) NSString *orderBy;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *cJobTypeName;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *photo;

@property(nonatomic,copy)NSString *huanXinId;
@property(nonatomic,copy)NSString *huanXinPassword;
@end
