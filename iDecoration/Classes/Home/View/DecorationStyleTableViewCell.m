//
//  DecorationStyleTableViewCell.m
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DecorationStyleTableViewCell.h"
#import "ZCHCustomView.h"

#define kStyleCode 4000
@implementation DecorationStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (NSInteger i = 0; i < 12; i++) {
        UIView *currentView = [self.contentView viewWithTag:kStyleCode + i];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [currentView addGestureRecognizer:tapGesture];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTypeWithIndex:tap:)]) {
        [self.delegate didSelectedTypeWithIndex:(tap.view.tag-kStyleCode) tap:tap];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
