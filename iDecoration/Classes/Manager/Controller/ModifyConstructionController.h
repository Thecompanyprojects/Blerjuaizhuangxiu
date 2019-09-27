//
//  ModifyConstructionController.h
//  iDecoration
//
//  Created by Apple on 2017/5/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"
#import "MainDiarySiteModel.h"

@interface ModifyConstructionController : SNViewController
@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) SiteModel *siteModel;//施工日志
@property (nonatomic, assign) MainDiarySiteModel *mainSiteModel;//主材日志
@property (nonatomic, assign) NSInteger companyOrShop;//0:company 1:shop
@property (nonatomic, assign) NSInteger ccComplete;//交工状态
@end
