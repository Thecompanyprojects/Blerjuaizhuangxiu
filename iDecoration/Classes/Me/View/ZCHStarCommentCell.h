//
//  ZCHStarCommentCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHConstructionCommentModel;

@protocol ZCHStarCommentCellDelegate <NSObject>

@optional
- (void)finishEditCommentWithObject:(id)object andIndex:(NSIndexPath *)indexPath;

@end

@interface ZCHStarCommentCell : UITableViewCell

@property (strong, nonatomic) ZCHConstructionCommentModel *model;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) BOOL isNewComment;

@property (weak, nonatomic) id<ZCHStarCommentCellDelegate> delegate;

@end
