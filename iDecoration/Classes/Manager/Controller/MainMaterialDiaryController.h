//
//  MainMaterialDiaryController.h
//  iDecoration
//
//  Created by Apple on 2017/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNNavigationController.h"

@interface MainMaterialDiaryController : SNViewController

@property (nonatomic, assign) NSInteger consID;

@property (nonatomic,copy) NSString *companyId;//公司id

@property (nonatomic,copy) NSString *agencysJob;//公司职位

@property (nonatomic,copy) NSString *companyFlag;//1 公司 2 店铺

@property (nonatomic,assign) BOOL isfromlocal;
@property (nonatomic, strong) NSString *flowerNumber;
@property (nonatomic, strong) NSString *pennantnumber;

@property (nonatomic,copy) NSString *companyType;
@property (nonatomic,copy) NSString *constructionType;
@property (nonatomic,copy) NSString *companyPhone;
@property (nonatomic,copy) NSString *companyLandline;
@end
