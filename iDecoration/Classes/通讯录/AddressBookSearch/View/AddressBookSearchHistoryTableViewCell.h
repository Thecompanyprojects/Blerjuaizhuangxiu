//
//  AddressBookSearchHistoryTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookSearchHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
