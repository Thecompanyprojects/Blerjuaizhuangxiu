//
//  ZCHConstructionVipController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBloc)(void);
@interface ZCHConstructionVipController : UITableViewController

// 公司Id
@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) RefreshBloc block;

@end
