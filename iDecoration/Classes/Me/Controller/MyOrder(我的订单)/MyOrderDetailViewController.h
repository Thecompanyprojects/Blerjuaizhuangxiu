//
//  MyOrderDetailViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "CompanyIncomeModel.h"
#import "MyOrderModel.h"


@interface MyOrderDetailViewController : SNViewController

// 我的订单列表传来的消息
@property (nonatomic, strong) MyOrderModel *myOrderModel;
@end
