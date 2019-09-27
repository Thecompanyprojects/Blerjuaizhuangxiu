//
//  ZCHSearchCooperateModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/10/16.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZCHCooperateListModel;


@interface ZCHSearchCooperateModel : NSObject

@property (assign, nonatomic) BOOL flag;


// 当前登录人职位编码
@property (nonatomic, copy) NSString *jobType;
// 合作企业商标
@property (nonatomic, copy) NSString *sloganLogo;
// 当前企业是否开通会员（0.未开通、1.开通。）
@property (nonatomic, copy) NSString *appVip;
// 公司数组
@property (nonatomic, strong) NSMutableArray <ZCHCooperateListModel *>*companyList;

@end
