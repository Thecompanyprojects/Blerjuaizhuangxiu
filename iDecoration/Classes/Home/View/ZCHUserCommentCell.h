//
//  ZCHUserCommentCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DesignTeamDetailModel;

@protocol ZCHUserCommentCellDelegate <NSObject>

@optional
- (void)getCellHeight:(CGFloat)cellHeight andIndex:(NSIndexPath *)index;

@end

@interface ZCHUserCommentCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ZCHUserCommentCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configWith:(DesignTeamDetailModel *)model;

@end
