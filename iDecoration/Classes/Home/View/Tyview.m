//
//  Tyview.m
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "Tyview.h"

@interface Tyview ()
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UIView *topV;
@end

@implementation Tyview

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - 设置样式
- (void)configView:(CGFloat)totalSore score:(CGFloat)score bottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor cornerRadius:(CGFloat)cornerRadius
{
    self.bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.bottomV.layer.cornerRadius = cornerRadius;
    self.bottomV.layer.masksToBounds = YES;
    CGFloat b = score/totalSore;
    CGFloat w = self.bottomV.width*b;
    self.topV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, self.height)];
    self.topV.layer.cornerRadius = cornerRadius;
    self.topV.layer.masksToBounds = YES;
    self.bottomV.backgroundColor = bottomColor;
    self.topV.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.bottomV];
    [self addSubview:self.topV];
}
@end
