//
//  EliteListViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EliteListTableViewCell.h"
#import "NewMyPersonCardController.h"
#import "EliteDetailViewController.h"
#import "GeniusSquareListModel.h"

@interface EliteListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger pageNo;
@property (copy, nonatomic) NSString *content;//搜索内容

- (void)createTableView;
- (void)Network;
- (void)endRefresh;
@end
