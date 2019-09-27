//
//  FlowersListTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlowersListModel;

@interface FlowersListTableViewCell : UITableViewCell
typedef void(^FlowersListTableViewCellBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UIButton *buttonStory;
@property (copy, nonatomic) FlowersListTableViewCellBlock blockDidTouchButton;
@property (copy, nonatomic) FlowersListTableViewCellBlock blockDidTouchIcon;

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index;
- (void)setModel:(FlowersListModel *)model;
@end
