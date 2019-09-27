//
//  ZCHProductsDetailCell.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHProductsDetailCell.h"

@interface ZCHProductsDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;


@end

@implementation ZCHProductsDetailCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
}

- (void)setDic:(NSDictionary *)dic {
    
    _dic = dic;
    self.introLabel.text = dic[@"content"];
    if ([dic[@"imgUrl"] isEqualToString:@""]) {
        self.bottomMargin.constant = -BLEJWidth + 20;
    } else {
        
        self.bottomMargin.constant = 10;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"imgUrl"]] placeholderImage:nil];
    } 
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
