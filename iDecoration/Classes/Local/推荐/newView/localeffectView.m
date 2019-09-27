//
//  localeffectView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localeffectView.h"

@interface localeffectView()
@property (nonatomic,strong) UIView *bgView;
@end

@implementation localeffectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.effectImg];
        [self addSubview:self.bgView];
        [self addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{

    __weak typeof (self) weakSelf = self;
    [weakSelf.effectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(109);
    }];
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.effectImg);
        make.right.equalTo(weakSelf.effectImg);
        make.bottom.equalTo(weakSelf.effectImg);
        make.height.mas_offset(14);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.effectImg);
        make.right.equalTo(weakSelf.effectImg);
        make.height.mas_offset(14);
        make.bottom.equalTo(weakSelf.bgView);
    }];
}

#pragma mark - getters

-(UIImageView *)effectImg
{
    if(!_effectImg)
    {
        _effectImg = [[UIImageView alloc] init];
        _effectImg.contentMode = UIViewContentModeScaleAspectFill;
        _effectImg.layer.masksToBounds = YES;
    }
    return _effectImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = White_Color;
        //_contentLab.text = @"北欧风公寓效果图";
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = White_Color;
        _bgView.alpha = 0.3;
    }
    return _bgView;
}




@end
