//
//  localstrategyView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localstrategyView.h"
#import <UIButton+LXMImagePosition.h>

@implementation localstrategyView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImg];
        [self addSubview:self.titleLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.timeLab];
        [self addSubview:self.readBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(104);
        make.height.mas_offset(69);
    }];
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(12);
        make.right.equalTo(weakSelf).with.offset(-10);
    }];
    
   // _contentLab.text = @"在我们生活中，大家一定接触到保温材料吧，今天小编就给大家详细讲解一下生活中的保温材料有…";
    _contentLab.preferredMaxLayoutWidth = (kSCREEN_WIDTH - 10.0 * 2-104);
    [_contentLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(7);
        make.height.mas_offset(29);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(7);
    }];
    [weakSelf.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.timeLab);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.height.mas_offset(11);
        make.width.mas_offset(40);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        //_leftImg.backgroundColor = [UIColor greenColor];
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
        _leftImg.layer.masksToBounds = YES;
    }
    return _leftImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor hexStringToColor:@"333333"];
        //_titleLab.text = @"管道保温材料有哪些？";
    }
    return _titleLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor hexStringToColor:@"777777"];
        _contentLab.numberOfLines = 2;
    }
    return _contentLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:11];
        _timeLab.textColor = [UIColor hexStringToColor:@"777777"];
    }
    return _timeLab;
}

-(UIButton *)readBtn
{
    if(!_readBtn)
    {
        _readBtn = [[UIButton alloc] init];
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_readBtn setTitleColor:[UIColor hexStringToColor:@"777777"] forState:normal];
        [_readBtn setImagePosition:LXMImagePositionLeft spacing:4];
        [_readBtn setImage:[UIImage imageNamed:@"skimming"] forState:normal];
    }
    return _readBtn;
}

@end
