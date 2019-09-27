//
//  MyOrderPageController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTypeAll = 0,
    OrderTypeNeedSure, // 待确定
    OrderTypeSured, // 已确认
};
@interface MyOrderPageController : SNViewController
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, assign) NSInteger agencyId;
@end
