//
//  CelebrityInterviewsTypeSelectedTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CelebrityInterviewsTypeSelectedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
