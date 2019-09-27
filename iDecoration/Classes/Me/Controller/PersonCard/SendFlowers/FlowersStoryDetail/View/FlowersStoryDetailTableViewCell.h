//
//  FlowersStoryDetailTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowersStoryDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index;
@end
