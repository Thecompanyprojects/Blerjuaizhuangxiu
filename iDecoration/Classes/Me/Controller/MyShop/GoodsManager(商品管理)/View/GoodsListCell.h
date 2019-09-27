//
//  GoodsListCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GoodsListModel.h"

@interface GoodsListCell : UICollectionViewCell

/**
 0：列表视图，1：格子视图
 */
@property (nonatomic, assign) BOOL isGrid;

@property (nonatomic, strong) GoodsListModel *model;
@property (nonatomic, assign) CGFloat cellWidth;

// 商品icon
@property (nonatomic, strong) UIImageView *iconIV;
// 商品名称
@property (nonatomic, strong) UILabel *nameLabel;
// 商品折扣视图
@property (nonatomic, strong) UIView *discountView;
// 商品价格视图
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UILabel *presentPriceLabel;
@property (nonatomic, strong) UILabel *oldPriceLabel;
//@property (nonatomic, strong) UILabel *collectionLabel;


@end
