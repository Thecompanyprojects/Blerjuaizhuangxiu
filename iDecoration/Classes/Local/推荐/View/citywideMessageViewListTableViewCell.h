//
//  citywideMessageViewListTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface citywideMessageViewListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelCity;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
