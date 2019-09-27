//
//  ConstructionDiaryTwoController.h
//  iDecoration
//
//  Created by Apple on 2017/7/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ConstructionDiaryTwoController : SNViewController
@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, copy) NSString *companyId;//公司id

@property (nonatomic,copy) NSString *agencysJob;//公司职位

@property (nonatomic,copy) NSString *companyFlag;//1 公司 2店铺
@property (nonatomic,copy) NSString *origin;
@property (nonatomic,assign) BOOL isfromlocal;
@property (nonatomic,copy) NSString *companyPhone;
@property (nonatomic,copy) NSString *companyLandline;
@property (nonatomic,copy) NSString *companyType;
@property (nonatomic,copy) NSString *constructionType;

@property (nonatomic, strong) NSString *flowerNumber;
@property (nonatomic, strong) NSString *pennantnumber;

@end
