//
//  EditCompanyPeopleController.h
//  iDecoration
//
//  Created by Apple on 2017/5/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyPeopleInfoModel.h"

@interface EditCompanyPeopleController : UIViewController
@property (nonatomic ,assign) NSInteger comPanyOrShop; //1:company 2:shop
@property (nonatomic, strong) CompanyPeopleInfoModel *model;
@end
