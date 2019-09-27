//
//  ZCHCaseAndBeautyController.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^RefreshBlock)();

@interface ZCHCaseAndBeautyController : SNViewController

// 是否是点击案例进来的
@property (assign, nonatomic) BOOL isCase;

@property (strong, nonatomic) NSMutableArray *caseArr;
@property (strong, nonatomic) NSMutableArray *beautyArr;
@property (strong, nonatomic) NSMutableDictionary *cardDic;
@property (strong, nonatomic) NSDictionary *companyDic;
@property (copy, nonatomic) NSString *logo;
@property (strong, nonatomic) NSArray *areaArr;

@property (copy, nonatomic) NSString *agencyId;

@property (copy, nonatomic) RefreshBlock block;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
