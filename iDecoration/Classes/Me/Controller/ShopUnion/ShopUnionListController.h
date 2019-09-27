//
//  ShopUnionListController.h
//  iDecoration
//
//  Created by sty on 2017/10/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ShopUnionListController : SNViewController
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *unionLogo;
@property (nonatomic, copy) NSString *unionNumber;
@property (nonatomic, copy) NSString *unionName;
@property (nonatomic, copy) NSString *unionPwd;
@property (nonatomic, assign) NSInteger unionId;
@property (nonatomic, assign) BOOL isLeader;//当前人员是否是盟主

@property (nonatomic, assign) BOOL isZManage;//当前人员在联盟活动中是否是总经理
@property (nonatomic, assign) BOOL isFManage;//当前人员在联盟活动中是否是经理
@end
