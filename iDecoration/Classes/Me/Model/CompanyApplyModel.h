//
//  CompanyApplyModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//


// 消息中心中 公司申请model

#import <Foundation/Foundation.h>

@interface CompanyApplyModel : NSObject
// 申请id
@property (nonatomic, assign) NSInteger applyId;
// 申请人员id
@property (nonatomic, assign) NSInteger agencysId;
// 申请公司id
@property (nonatomic, assign) NSInteger companyId;
// 申请姓名
@property (nonatomic, strong) NSString *applyName;
// 申请时间
@property (nonatomic, assign) NSInteger applyTime;
// 申请职位
@property (nonatomic, assign) NSInteger applyJob;
//申请状态（0：未处理  1：申请通过  2： 申请不通过   3： 申请过期）
@property (nonatomic, assign) NSInteger applyStatus;
//申请公司经理id
@property (nonatomic, strong) NSString *manager;
// 申请是否阅读(0:  未读   1： 已读)
@property (nonatomic, assign) NSInteger applyRead;
// 申请公司名称
@property (nonatomic, strong) NSString *companyName;
// 申请天数（>3 已过期 ， 只能删除消息）
@property (nonatomic, assign) NSInteger day;
// 申请人头像
@property (nonatomic, strong) NSString *logo;
//申请人真是姓名
@property (nonatomic, strong) NSString *agencysName;
//申请职位名称
@property (nonatomic, strong) NSString *jobName;

@end






