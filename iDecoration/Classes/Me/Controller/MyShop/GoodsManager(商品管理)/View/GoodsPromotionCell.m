//
//  GoodsPromotionCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsPromotionCell.h"

@implementation GoodsPromotionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.stateLabel.textColor = kMainThemeColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(PromptModel *)model {
    _model = model;
    NSInteger type = model.activityType.integerValue; // // 活动类型  活动类型1、全店满送 2、商品满送 3、全店满减 4、商品满减 5、全店优惠券 6、商品优惠券 7、套餐
    NSString *typeName = @"";
    switch (type) {
        case 1:
            typeName = @"全店满送";
            break;
        case 2:
            typeName = @"商品满送";
            break;
        case 3:
            typeName = @"全店满减";
            break;
        case 4:
            typeName = @"商品满减";
            break;
        case 5:
            typeName = @"全店优惠券";
            break;
        case 6:
            typeName = @"商品优惠券";
            break;
        case 7:
            typeName = @"优惠套餐";
            break;
        default:
            break;
    }
    self.typeLabel.text = typeName;
    self.nameLabel.text = model.activityName;
    if (model.goodsList.count > 0) {
        self.goodsNumLabel.text = [NSString stringWithFormat:@"(%ld件商品)", model.goodsList.count];
    }
    
    NSTimeInterval nowDate = [[NSDate date] timeIntervalSince1970];
    if (nowDate > model.endTime.doubleValue/1000.0) {
        self.stateLabel.text = @"已失效";
        self.stateLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.stateLabel.text = @"进行中";
        self.stateLabel.textColor = kMainThemeColor;
    }
//    self.stateLabel.text = [model.isCancel isEqualToString:@"1"] ? @"已失效" : @"进行中";
    
    NSString *startTimeStr = [NSObject timeStringFromTimeIntervalString:model.startTime.doubleValue/1000.0 WithFromatter:@"yyyy-MM-dd HH:mm:ss"];
     NSString *endTimeStr = [NSObject timeStringFromTimeIntervalString:model.endTime.doubleValue/1000.0 WithFromatter:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [NSString stringWithFormat:@"%@至%@", startTimeStr, endTimeStr];
    
    for (int i = 0; i < model.goodsList.count; i ++) {
        PromptGoodsList *item = model.goodsList[i];
        if (item.goodsDisplay.length > 0) {
            UIImageView *imageV = [[UIImageView alloc] init];
            [imageV sd_setImageWithURL:[NSURL URLWithString:item.goodsDisplay]];
            [self.scrollView addSubview:imageV];
            imageV.frame = CGRectMake(i * (55 + 5), 0, 55, 55);
        }
    }
    self.scrollView.contentSize = CGSizeMake(60 * model.goodsList.count, 55);
    
}
@end
