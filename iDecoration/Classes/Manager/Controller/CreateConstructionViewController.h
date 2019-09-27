//
//  CreateConstructionViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface CreateConstructionViewController : SNViewController
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *roleTypeId;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, copy) NSString *constructionType;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countyId;
@end
