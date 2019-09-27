//
//  localshopView1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localshopView1.h"

@implementation localshopView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.shopImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.moneyLab];
       
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
        make.height.mas_offset(89);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(3);
        make.right.equalTo(weakSelf).with.offset(-3);
        make.top.equalTo(weakSelf.shopImg.mas_bottom);
        make.height.mas_offset(11);
    }];
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom);
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


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:10];
        //_nameLab.text = @"华润漆 易净缤纷金装";
        _nameLab.textColor = [UIColor hexStringToColor:@"444444"];
    }
    return _nameLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont systemFontOfSize:10];
        _moneyLab.textColor = [UIColor hexStringToColor:@"FF0000"];
        //_moneyLab.text = @"￥322";
    }
    return _moneyLab;
}




@end
