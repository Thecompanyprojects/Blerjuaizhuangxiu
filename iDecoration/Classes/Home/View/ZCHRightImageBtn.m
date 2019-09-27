//
//  ZCHRightImageBtn.m
//  iDecoration
//
//  Created by 赵春浩 on 17/10/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHRightImageBtn.h"

#define Margin 3


@implementation ZCHRightImageBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self  = [super initWithFrame:frame]) {
        
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.myFont = [UIFont systemFontOfSize:14];
    [self.titleLabel setFont:self.myFont];
    [self setTitleColor:White_Color forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateSelected];
    self.adjustsImageWhenHighlighted = NO;
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.layer.masksToBounds = NO;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    
    titleF.origin.x = 0;
    titleF.size.width = titleF.size.width  > 65 ? 65 : titleF.size.width;
    self.titleLabel.frame = titleF;
    
    imageF.origin.x = CGRectGetMaxX(titleF) + Margin;
    self.imageView.frame = imageF;
    
//    self.titleLabel.left = self.imageView.left;
//    CGFloat width = CGRectGetMaxX(self.titleLabel.frame) > 65 ? 65 : CGRectGetMaxX(self.titleLabel.frame);
//    self.titleLabel.width = width;
//    self.imageView.left = width + Margin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    [self sizeToFit];
    self.width = 80;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    
    [super setImage:image forState:state];
    [self sizeToFit];
    self.width = 80;
}

- (void)setMyFont:(UIFont *)myFont {
    
    _myFont = myFont;
    [self.titleLabel setFont:myFont];
}

@end
