//
//  citywideMessageViewList.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface citywideMessageViewList : UIView<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) UITableView *tableView;
- (void)reload;
@end
