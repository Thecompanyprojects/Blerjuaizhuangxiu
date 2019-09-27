//
//  OnLineVipViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/2/5.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SuccessBlock)(void);

@interface OnLineVipViewController : UITableViewController

@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) SuccessBlock successBlock;
@end
