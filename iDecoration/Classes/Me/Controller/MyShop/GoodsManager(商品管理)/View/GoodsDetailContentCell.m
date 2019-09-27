//
//  GoodsDetailContentCell.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GoodsDetailContentCell.h"

@implementation GoodsDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.layer.masksToBounds = YES;
    
    
    self.imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction)];
    [self.imageV addGestureRecognizer:tapGR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)imageTapAction {
    if (self.clickImageBlock) {
        self.clickImageBlock();
    }
}
@end
