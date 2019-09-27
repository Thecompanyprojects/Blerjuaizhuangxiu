//
//  HomeClassificationDetailTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeClassificationDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *viewSelected;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)selectedCell:(BOOL)isSelected;
@end
