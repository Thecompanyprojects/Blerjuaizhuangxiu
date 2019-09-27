//
//  AddCompanyPeopleController.h
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubsidiaryModel.h"

@interface AddCompanyPeopleController : SNViewController
@property (nonatomic, strong) SubsidiaryModel *model;
@property (nonatomic ,assign) NSInteger comPanyOrShop; //1:company 2:shop
@end
