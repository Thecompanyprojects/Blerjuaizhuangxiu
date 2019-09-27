//
//  OwnerEvaluateCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OwnerEvaluateModel;

@protocol OwnerEvaluateCellDelegate <NSObject>

@optional
- (void)getCellHeight:(CGFloat)cellHeight andIndex:(NSIndexPath *)index;

@end

@interface OwnerEvaluateCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<OwnerEvaluateCellDelegate> delegate;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configWith:(OwnerEvaluateModel *)model;

@end
