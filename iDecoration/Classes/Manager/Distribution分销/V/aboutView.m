//
//  aboutView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "aboutView.h"

@implementation aboutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.rightImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.contentLab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
   
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(42);
        make.height.mas_offset(42);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-12);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(14);
        make.right.equalTo(weakSelf.rightImg.mas_left).with.offset(-2);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.nameLab);
        make.left.equalTo(weakSelf.nameLab);
        make.bottom.equalTo(weakSelf).with.offset(-14);
    }];
}

#pragma mark - getters


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _nameLab;
}


-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor hexStringToColor:@"616161"];
    }
    return _contentLab;
}


-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        
    }
    return _rightImg;
}



@end
