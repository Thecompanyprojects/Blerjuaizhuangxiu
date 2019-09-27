//
//  goodsCollectionViewCell.m
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "goodsCollectionViewCell.h"

@implementation goodsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(goodsModel *)model{

    if (model.display) {
        [self.goodsImgView  sd_setImageWithURL:[NSURL URLWithString:model.display] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    }
    
    if (model.price) {
        
        self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%@",model.price];
    }
    
    if (model.name) {
        self.goodsNameLable.text = model.name;
    }

}
@end
