//
//  BatchManagerCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"


@interface BatchManagerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *presentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
// 收藏量
@property (weak, nonatomic) IBOutlet UILabel *collectionLabel;
// 优惠活动视图
@property (weak, nonatomic) IBOutlet UIView *discountView;


@property (nonatomic, strong) GoodsListModel *model;
@end
