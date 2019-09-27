//
//  ZCHGoodsDetailCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHGoodsDetailModel;

@protocol ZCHGoodsDetailCellDelegate <NSObject>

- (void)cellHeightWithIndexpath:(NSIndexPath *)indexpath andCellHeight:(CGFloat)cellHeight;

@end

@interface ZCHGoodsDetailCell : UITableViewCell

@property (strong, nonatomic) ZCHGoodsDetailModel *model;
@property (strong, nonatomic) NSIndexPath *indexpath;
@property (weak, nonatomic) id<ZCHGoodsDetailCellDelegate> delegate;

@property (assign, nonatomic) BOOL isShowImage;

@end
