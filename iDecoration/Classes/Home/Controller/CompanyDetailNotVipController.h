//
//  CompanyDetailNotVipController.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface CompanyDetailNotVipController : SNViewController

@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic,copy) NSString *designsId;
@property (nonatomic, assign) BOOL isCompany;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
