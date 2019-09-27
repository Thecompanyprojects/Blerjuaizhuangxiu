//
//  STYRedResultController.h
//  iDecoration
//
//  Created by sty on 2018/3/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "ZCHCouponModel.h"

@interface STYRedResultController : SNViewController

@property (nonatomic, assign) NSInteger fromTag;// 0:扫码进入  1:输入兑换码进入

@property (nonatomic, strong) ZCHCouponModel *model;
@property (nonatomic, copy) NSString *code;
@end
