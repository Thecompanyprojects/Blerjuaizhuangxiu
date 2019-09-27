//
//  CreatShopUnionController.h
//  iDecoration
//
//  Created by sty on 2017/10/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNNavigationController.h"

@interface CreatShopUnionController : SNViewController

@property (nonatomic, copy) void (^creatUnionBlock)(NSMutableDictionary *dict);
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger IsEdit;//0:创建 1:编辑

@property (nonatomic, copy) NSString *unionLogo;
@property (nonatomic, copy) NSString *unionNumber;
@property (nonatomic, copy) NSString *unionName;
@property (nonatomic, copy) NSString *unionPwd;
@property (nonatomic, assign) NSInteger unionId;
@end
