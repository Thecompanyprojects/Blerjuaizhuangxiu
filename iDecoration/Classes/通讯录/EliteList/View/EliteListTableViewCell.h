//
//  EliteListTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GeniusSquareListModel;

@interface EliteListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelRight;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelCompany;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)setModel:(GeniusSquareListModel *)model;
@end
