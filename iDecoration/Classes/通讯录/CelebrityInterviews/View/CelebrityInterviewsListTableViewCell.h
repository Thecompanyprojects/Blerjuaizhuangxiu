//
//  CelebrityInterviewsListTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/19.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CelebrityInterviewsListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *buttonLike;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *arrayImageViewLayout;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeNumber;
@property (weak, nonatomic) IBOutlet UILabel *labelWatchNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlay;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;
/**
 是否是在list显示该cell
 若是在list显示更改约束
 */
@property (assign, nonatomic) BOOL isListView;

+ (instancetype)cellWithTableView:(UITableView *)tableView AndIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
