//
//  VipDetailController.h
//  iDecoration
//
//  Created by Apple on 2017/5/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(void);
@interface VipDetailController : UITableViewController

@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) SuccessBlock successBlock;

@end
