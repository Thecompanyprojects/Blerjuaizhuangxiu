//
//  localshopView0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localshopView0.h"

@interface localshopView0()
@property (nonatomic,strong) UIView *bgView;
@end

@implementation localshopView0

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shopImg];
        [self addSubview:self.bgView];
        [self addSubview:self.nameLab];
        [self setuplayout];
        
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.shopImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_offset(22);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(4);
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bgView);
    }];
}

#pragma mark - getters

-(UIImageView *)shopImg
{
    if(!_shopImg)
    {
        _shopImg = [[UIImageView alloc] init];
        _shopImg.contentMode = UIViewContentModeScaleAspectFill;
        _shopImg.layer.masksToBounds = YES;
    }
    return _shopImg;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.alpha = 0.3;
        _bgView.backgroundColor = Black_Color;
    }
    return _bgView;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = White_Color;
        _nameLab.font = [UIFont systemFontOfSize:10];
        _nameLab.text = @"双虎家私名品 欧式床";
    }
    return _nameLab;
}




@end
