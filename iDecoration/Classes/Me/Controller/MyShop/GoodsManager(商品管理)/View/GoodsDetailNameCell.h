//
//  GoodsDetailNameCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"


@interface GoodsDetailNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UILabel *presentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainLabelHeight;


@property (nonatomic, strong) NSArray *discountTitleArray;




@property (nonatomic, strong) GoodsDetailModel *model;

@end
