//
//  ZCHGoodsDetailCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHGoodsDetailCell.h"
#import "ZCHGoodsDetailModel.h"
#include <CoreGraphics/CoreGraphics.h>
#include <ImageIO/ImageIOBase.h>
#import <ImageIO/ImageIO.h>


@interface ZCHGoodsDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeignt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopMargin;

@end

@implementation ZCHGoodsDetailCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ZCHGoodsDetailModel *)model {
    
    if (_model != model) {
        _model = model;
    }
    self.contentLabel.text = model.content;
    self.iconView.contentMode = UIViewContentModeScaleToFill;
    CGSize sizeContent = [model.content boundingRectWithSize:CGSizeMake(BLEJWidth - 20, MAXFLOAT) withFont:[UIFont systemFontOfSize:16]];
    CGFloat cellHeight;
    
    if (model.content == nil || [model.content isEqualToString:@""]) {
        
        cellHeight = 0;
        self.labelTopMargin.constant = 5;
    } else {
        
        //  > 20 ? sizeContent.height : 20
//        self.contentLabel.height = sizeContent.height;
        cellHeight = sizeContent.height + 30;
        self.contentLabel.height = cellHeight;
        self.labelTopMargin.constant = 0;
    }
    
    self.contentHeignt.constant = cellHeight;
    [self layoutIfNeeded];
    if (self.isShowImage) {
        
//        self.contentLabel.hidden = NO;
//        self.contentHeignt.constant = cellHeight;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:nil];
    } else {
        
//        self.contentLabel.hidden = YES;
//        self.contentHeignt.constant = 0;
        self.iconView.image = [UIImage imageNamed:@"default_icon"];
//        [self.iconView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"default_icon"]];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(cellHeightWithIndexpath:andCellHeight:)]) {
        
        [self.delegate cellHeightWithIndexpath:self.indexpath andCellHeight:cellHeight];
    }
}

//#pragma mark - 计算图片按照比例显示
//- (CGSize)calculateImageSizeWithSize:(CGSize)size {
//    
//    CGSize finalSize;
//    if (size.width / BLEJWidth > size.height / BLEJHeight) {
//        
//        finalSize.width = size.width * BLEJWidth / size.width;
//        finalSize.height = size.height * BLEJWidth / size.width;
//    } else {
//        
//        finalSize.width = size.width * BLEJHeight / size.height;
//        finalSize.height = size.height * BLEJHeight / size.height;
//    }
//    return finalSize;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
