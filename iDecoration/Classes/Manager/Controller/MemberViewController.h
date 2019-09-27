//
//  MemberViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface MemberViewController : SNViewController
@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) NSInteger consCreatPeopleID;//工地创建人id
@property (nonatomic, assign) BOOL isComplete;//是否交工  yes：交工  no：未交工
//群聊ID
@property(nonatomic,copy)NSString *groupid;
// 小区名称 用来创建为创建群组的群名称
@property (nonatomic, copy) NSString *socialName;

@property (nonatomic, assign) NSInteger index;//1:从施工日志进入   2:从主材日志进入
@property (nonatomic,copy) NSString *companyFlag;//1 公司 2 店铺
@end
