//
//  GoodsDetailRecommendGoodCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailRecommendGoodCell.h"

@implementation GoodsDetailRecommendGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageVHeightCon.constant = (kSCREEN_WIDTH - 5)/2.0;
    self.rImageVHeightCon.constant = (kSCREEN_WIDTH - 5)/2.0;
    
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.layer.masksToBounds = YES;
    self.rImageV.contentMode = UIViewContentModeScaleAspectFill;
    self.rImageV.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLeftModel:(GoodsListModel *)leftModel {
    _leftModel = leftModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:leftModel.display]];
    self.nameLabel.text = leftModel.name;
    self.presentPrice.text = [NSString stringWithFormat:@"￥%@", leftModel.price];
    self.collectionNum.text = [NSString stringWithFormat:@"%ld收藏", leftModel.collectionNum];
}

- (void)setRightModel:(GoodsListModel *)rightModel {
    _rightModel = rightModel;
    [self.rImageV sd_setImageWithURL:[NSURL URLWithString:rightModel.display]];
    self.rNameLabel.text = rightModel.name;
    self.rPresentPriceLabel.text = [NSString stringWithFormat:@"￥%@", rightModel.price];
    self.rCollectionNumLabel.text = [NSString stringWithFormat:@"%ld收藏", rightModel.collectionNum];
}

- (void)setLeftDiscountTitleArray:(NSArray *)leftDiscountTitleArray {
    _leftDiscountTitleArray = leftDiscountTitleArray;
    UILabel *lastLabel = nil;
    for (int i = 0; i < leftDiscountTitleArray.count; i ++) {
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = 4;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = self.leftDiscountTitleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelWidth = [self getWidthWithText:label.text height:14 font:12] + 4;
        [self.discountView addSubview:label];
        if (i == 0) {
            label.frame = CGRectMake(8, 4, labelWidth, 14);
        } else {
            CGFloat x = CGRectGetMaxX(lastLabel.frame) + 3;
            CGFloat y = lastLabel.frame.origin.y;;
            
            if ((kSCREEN_WIDTH - 5)/2.0 - 8 >= labelWidth) {
                y = lastLabel.frame.origin.y;
            } else {
                // 超过两行的不显示了
                return;
            }
            label.frame = CGRectMake(x, y, labelWidth, 14);
        }
        lastLabel = label;
    }

}

- (void)setRightDiscountTitleArray:(NSArray *)rightDiscountTitleArray {
    _rightDiscountTitleArray = rightDiscountTitleArray;
    UILabel *lastLabel = nil;
    for (int i = 0; i < rightDiscountTitleArray.count; i ++) {
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = 4;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = self.rightDiscountTitleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelWidth = [self getWidthWithText:label.text height:14 font:12] + 4;
        [self.rDiscountView addSubview:label];
        if (i == 0) {
            label.frame = CGRectMake(8, 4, labelWidth, 14);
        } else {
            CGFloat x = CGRectGetMaxX(lastLabel.frame) + 3;
            CGFloat y = lastLabel.frame.origin.y;;
            
            if ((kSCREEN_WIDTH - 5)/2.0 - 8  >= labelWidth) {
                y = lastLabel.frame.origin.y;
            } else {
                return;
            }
            label.frame = CGRectMake(x, y, labelWidth, 14);
        }
        lastLabel = label;
    }
}
//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}
@end
