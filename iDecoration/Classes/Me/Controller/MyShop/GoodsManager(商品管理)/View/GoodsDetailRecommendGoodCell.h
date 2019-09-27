//
//  GoodsDetailRecommendGoodCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

@interface GoodsDetailRecommendGoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *presentPrice;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVHeightCon;


@property (weak, nonatomic) IBOutlet UIView *rightBgView;
@property (weak, nonatomic) IBOutlet UIImageView *rImageV;
@property (weak, nonatomic) IBOutlet UILabel *rNameLabel;
@property (weak, nonatomic) IBOutlet UIView *rDiscountView;
@property (weak, nonatomic) IBOutlet UILabel *rPresentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rOldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rCollectionNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rImageVHeightCon;


@property (nonatomic, strong) GoodsListModel *leftModel;
@property (nonatomic, strong)GoodsListModel *rightModel;

@property (nonatomic, strong) NSArray *leftDiscountTitleArray;
@property (nonatomic, strong) NSArray *rightDiscountTitleArray;
@end
