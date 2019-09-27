//
//  ZCHAddShopperCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHAddShopperCell.h"

@interface ZCHAddShopperCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hadExpiredLabel;

@end


@implementation ZCHAddShopperCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"merchantLogo"]] placeholderImage:nil];
    self.nameLabel.text = dic[@"merchantName"];
    self.typeLabel.text = dic[@"typeName"];
    self.timeLabel.hidden = YES;
    self.hadExpiredLabel.hidden = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
