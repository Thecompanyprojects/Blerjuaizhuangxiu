//
//  GroupManagerCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupManagerCell;
@protocol GroupManagerCellDelegate <NSObject>

- (void)groupManagerCell:(GroupManagerCell *)cell delegateActionAtIndex:(NSIndexPath *)indexPath;
- (void)groupManagerCell:(GroupManagerCell *)cell moveUpActionFromIndex:(NSIndexPath *)indexPath;
- (void)groupManagerCell:(GroupManagerCell *)cell moveDownActionFromIndex:(NSIndexPath *)indexPath;
@end

@interface GroupManagerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moveUpButton;
@property (weak, nonatomic) IBOutlet UIButton *moveDownButton;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<GroupManagerCellDelegate> delegate;
@end
