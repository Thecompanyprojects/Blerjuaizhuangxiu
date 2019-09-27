//
//  NotVipYellowPageViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "SubsidiaryModel.h"

@interface NotVipYellowPageViewController : SNViewController
@property (nonatomic, strong) SubsidiaryModel *modelSubsidiary;
@property (nonatomic, strong) NSString *companyID;
// 非会员美文id 根据是否大于0判断是否有美文
@property (nonatomic, strong) NSString *noVipDesignId;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, assign) BOOL isImplement;// 是否是执行经理
@property (nonatomic, assign) NSInteger agencyJob; // 职位
@property (assign, nonatomic) BOOL isEdit;
@property (nonatomic, copy) NSString *origin;
@end
