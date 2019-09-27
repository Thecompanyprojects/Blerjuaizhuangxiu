//
//  ShopUnionListCommonCell.m
//  iDecoration
//
//  Created by sty on 2017/10/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ShopUnionListCommonCell.h"

@implementation ShopUnionListCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.UnionlogoImgV.layer.masksToBounds = YES;
//    self.UnionlogoImgV.layer.cornerRadius = 35;
    self.unionNumRightCont.constant = 0;
}
-(void)configWith:(id)data{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
