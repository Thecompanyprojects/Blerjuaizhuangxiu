//
//  ConstructionDiaryViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/3/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ConstructionDiaryViewController : SNViewController

@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) BOOL isComplete;

@property (nonatomic,copy) NSString *companyId;//公司ID

@property (nonatomic,copy) NSString *agencysJob;

@property (nonatomic,copy) NSString *companyFlag;

@property (nonatomic,copy) NSString *origin;
@end
