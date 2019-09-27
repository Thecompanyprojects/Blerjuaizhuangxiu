//
//  GoodsDetailNameCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailNameCell.h"

@implementation GoodsDetailNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsDetailModel *)model {
    _model = model;
    self.nameLabel.text = model.name;
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.oldPriceLabel.text = @""; // 格式： 原价￥999
    
    self.explainLabel.text = model.cutLine;
    self.explainLabelHeight.constant = [self.explainLabel.text isEqualToString:@""] ? 8 : 22;
}

- (void)setDiscountTitleArray:(NSArray *)discountTitleArray {
    _discountTitleArray = discountTitleArray;
//    详情上的三个折扣标签 去掉了
//    UILabel *lastLabel = nil;
//    for (int i = 0; i < discountTitleArray.count; i ++) {
//        UILabel *label = [UILabel new];
//        label.layer.cornerRadius = 4;
//        label.layer.borderColor = [UIColor redColor].CGColor;
//        label.layer.borderWidth = 1;
//        label.layer.masksToBounds = YES;
//        label.textColor = [UIColor redColor];
//        label.font = [UIFont systemFontOfSize:12];
//        label.text = self.discountTitleArray[i];
//        label.textAlignment = NSTextAlignmentCenter;
//
//        CGFloat labelWidth = [self getWidthWithText:label.text height:14 font:12] + 4;
//        [self.discountView addSubview:label];
//        if (i == 0) {
//            label.frame = CGRectMake(8, 4, labelWidth, 14);
//        } else {
//            CGFloat x = CGRectGetMaxX(lastLabel.frame) + 3;
//            CGFloat y = lastLabel.frame.origin.y;;
//
//            if (kSCREEN_WIDTH - x - 8 >= labelWidth) {
//                y = lastLabel.frame.origin.y;
//            } else {
//                x = 8;
//                y = lastLabel.frame.origin.y + 18;
//            }
//            label.frame = CGRectMake(x, y, labelWidth, 14);
//        }
//        lastLabel = label;
//    }
//    self.discountViewHeight.constant = CGRectGetMaxY(lastLabel.frame) + 8;
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
