//
//  newrankingView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newrankingView.h"

@interface newrankingView()

@end

@implementation newrankingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImg];
        [self addSubview:self.rightImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.numberLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(54);
        make.height.mas_offset(54);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(20);
    }];
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(24);
        make.height.mas_offset(32);
        make.right.equalTo(weakSelf).with.offset(-20);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg).with.offset(6);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(14);
        make.right.equalTo(weakSelf.rightImg.mas_left).with.offset(-14);
        
    }];
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(4);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
       
    }
    return _leftImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = [UIColor hexStringToColor:@"010101"];
    }
    return _nameLab;
}

-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        
    }
    return _rightImg;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.font = [UIFont systemFontOfSize:12];
        _numberLab.textColor = [UIColor redColor];

    }
    return _numberLab;
}


@end

