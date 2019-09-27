//
//  MyConstructionSiteViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/2/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface MyConstructionSiteViewController : SNViewController
@property (nonatomic,copy) NSString *agencysJob;//身份id  1002  总经理
//@property (nonatomic,copy) NSString *implement;//1 是执行经理
@property (assign, nonatomic) BOOL implement;

@property (nonatomic,copy) NSString *companyFlag;//1 公司 2 店铺
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *countyId;
@end
