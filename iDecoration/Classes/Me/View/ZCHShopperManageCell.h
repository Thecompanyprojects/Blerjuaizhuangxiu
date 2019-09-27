//
//  ZCHShopperManageCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHShopperManageModel;

@protocol ZCHShopperManageCellDelegate <NSObject>

@optional
- (void)didClickContinueBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZCHShopperManageCell : UITableViewCell

@property (strong, nonatomic) ZCHShopperManageModel *model;
@property (weak, nonatomic) id<ZCHShopperManageCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;


@end
