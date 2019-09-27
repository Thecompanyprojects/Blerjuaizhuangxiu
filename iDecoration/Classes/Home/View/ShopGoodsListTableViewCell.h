//
//  ShopGoodsListTableViewCell.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetailModel.h"


@interface ShopGoodsListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *goodsArr;
@property (nonatomic, strong) ShopDetailModel *detailModel;
@property (nonatomic, strong) UILabel *descriptionLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)stle reuseIdentifier:(NSString *)resuseIdentifier goodsArray:(NSArray *)goodsArr detailModel:(ShopDetailModel *)model;

@end
