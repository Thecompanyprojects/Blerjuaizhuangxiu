//
//  MainMaterialMemberModel.h
//  iDecoration
//
//  Created by Apple on 2017/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainMaterialMemberModel : NSObject
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *cpLimitsId;//职位编号
@property (nonatomic, copy) NSString *cpConstructionId;
@property (nonatomic, copy) NSString *personId;//关联id
@property (nonatomic, copy) NSString *cpPersonId;//人员id
@property (nonatomic, copy) NSString *cJobTypeName;
@property (nonatomic, copy) NSString *photo;


@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *cJobTypeId;
@property (nonatomic, copy) NSString *rongUserId;

@property (nonatomic, copy) NSString *orderBy;
@property (nonatomic, copy) NSString *deleteFlag;
@property (nonatomic, copy) NSString *areaName;


@property(nonatomic,copy)NSString *huanXinId;
@property(nonatomic,copy)NSString *huanXinPassword;
@end
