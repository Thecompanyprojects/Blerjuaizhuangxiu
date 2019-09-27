//
//  GoodsPromotionCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PromptModel.h"

@interface GoodsPromotionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodsNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLabelWidth;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;



@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (nonatomic,strong) PromptModel *model;

@end
