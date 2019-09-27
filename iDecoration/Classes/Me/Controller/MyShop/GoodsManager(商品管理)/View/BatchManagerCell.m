//
//  BatchManagerCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BatchManagerCell.h"

@implementation BatchManagerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIControl *control in self.subviews) {
        if (![control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            continue;
        }
        
        for (UIView *subView in control.subviews) {
            if (![subView isKindOfClass: [UIImageView class]]) {
                continue;
            }
            
            UIImageView *imageView = (UIImageView *)subView;
            if (self.selected) {
                imageView.image = [UIImage imageNamed:@"water_selectCircle"]; // 选中时的图片
            } else {
//                imageView.image = [UIImage imageNamed:@"water_Circle"];   // 未选中时的图片
            }
        }
    }
}

- (void)setModel:(GoodsListModel *)model {
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.display]];
    self.nameLabel.text = model.name;
    self.discountView.backgroundColor = [UIColor whiteColor];
    self.presentPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.price] ;
    self.oldPriceLabel.text = @"";  // 原价 没有
    self.collectionLabel.text = [NSString stringWithFormat:@"%ld 收藏", model.collectionNum];  // 收藏没有
    
    //折扣视图
    [self.discountView removeAllSubViews];
//    NSArray *discountTitleArray = @[@"测试折扣"];
    NSMutableArray *mulArr = [NSMutableArray array];
    NSInteger count = model.activityList.count > 3 ? 3 : model.activityList.count;
    for (int i = 0; i < count; i ++) {
        ActivityListModel *amodel = model.activityList[i];
        [mulArr addObject:amodel.activityName];
    }
    NSArray *discountTitleArray = [mulArr copy];
    UILabel *lastLabel = nil;
    CGFloat labelHeight = 14;
    for (int i = 0; i < discountTitleArray.count; i ++) {
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = 2;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:11];
        label.text = discountTitleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelWidth = [self getWidthWithText:label.text height:labelHeight font:11] + 4;
        if (i == 0) {
            label.frame = CGRectMake(2, 2, labelWidth, labelHeight);
        } else {
            CGFloat x = CGRectGetMaxX(lastLabel.frame) + 3;
            CGFloat y = lastLabel.frame.origin.y;;
            
            CGFloat discountViewWidth = model.isYellowPageClassifyLayout ? (kSCREEN_WIDTH - 120 - 90):(kSCREEN_WIDTH - 120);
            if (discountViewWidth - x - 2 >= labelWidth) { // discountViewWidth 为 discountView 视图的宽度
                y = lastLabel.frame.origin.y;
            } else {
                x = 2;
                y = lastLabel.frame.origin.y + labelHeight + 2;
                if (y + labelHeight + 2 > 60) { // 60 为 discountView 视图的高度 的大概高度
                    return;
                }
            }
            label.frame = CGRectMake(x, y, labelWidth, labelHeight);
            
        }
        
        [self.discountView addSubview:label];
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
