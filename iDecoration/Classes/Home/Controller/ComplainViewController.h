//
//  ComplainViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/7/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComplainViewController : UITableViewController

@property (nonatomic, assign) NSInteger companyID;

@property (nonatomic, assign) NSInteger complainFrom; // 0店铺投诉1本案设计投诉2店铺简介3计算器4活动详情
@end
