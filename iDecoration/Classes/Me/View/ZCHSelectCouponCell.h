//
//  ZCHSelectCouponCell.h
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCHCouponModel.h"

@protocol ZCHSelectCouponCellDelegate <NSObject>

@optional
- (void)didClickSelectWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZCHSelectCouponCell : UITableViewCell

@property (strong, nonatomic) ZCHCouponModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ZCHSelectCouponCellDelegate> delegate;

@end
