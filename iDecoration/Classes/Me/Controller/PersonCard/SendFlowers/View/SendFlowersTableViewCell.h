//
//  SendFlowersTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendFlowersTableViewCell : UITableViewCell
typedef void(^SendFlowersTableViewCellBlock)(void);
@property (copy, nonatomic) SendFlowersTableViewCellBlock blockDidTouchImageViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelected;
@property (weak, nonatomic) IBOutlet UILabel *labelDetail;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
