//
//  ZCHGoodsHeaderView.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHGoodsHeaderView.h"

@interface ZCHGoodsHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZCHGoodsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView.backgroundColor = kBackgroundColor;
    self.iconView.layer.masksToBounds = YES;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    
    [self.iconView sd_setImageWithURL:dataDic[@"display"] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    self.nameLabel.text = dataDic[@"name"];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", dataDic[@"price"]];
}


- (void)setModel:(goodsModel *)model{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.display] placeholderImage:[UIImage imageNamed:@"default_icon"]];
    
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
