//
//  DiscountPackageViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/7/24.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountPackageModel.h"
#import "DiscountPackageTableViewCell.h"
#import "AppDelegate.h"
#import "ZCHPublicWebViewController.h"
#import "DiscountPackageFooterView.h"

#define KValueForKey(a) self.model.arrayPay[indexPath.row - 1][a]

NS_ASSUME_NONNULL_BEGIN

@interface DiscountPackageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DiscountPackageModel *model;
@property (strong, nonatomic) NSString *companyId;

- (void)pay;
@end

NS_ASSUME_NONNULL_END
