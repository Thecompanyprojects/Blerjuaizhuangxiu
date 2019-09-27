//
//  goodsCollectionViewCell.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsModel.h"

@interface goodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLable;


@property(nonatomic,strong)goodsModel *model;

@end
