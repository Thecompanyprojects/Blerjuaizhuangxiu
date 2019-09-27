//
//  ShopDetailMidCell.m
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopDetailMidCell.h"

@implementation ShopDetailMidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleL.font = [UIFont systemFontOfSize:16];
    self.contentL.font = [UIFont systemFontOfSize:16];
    
    self.flagLabel.layer.cornerRadius = self.flagLabel.width/2.0;
    self.flagLabel.layer.masksToBounds = YES;
    self.flagLabel.hidden = YES;
}

-(void)configData:(id)data{
    if ([data isKindOfClass:[NSString class]]) {
        NSString *str = data;
        self.titleL.text = str;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
