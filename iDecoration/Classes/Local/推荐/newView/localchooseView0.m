//
//  localchooseView0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localchooseView0.h"

@interface localchooseView0()
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *goBtn;
@property (nonatomic,strong) UIImageView *img;
@end

@implementation localchooseView0

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.goBtn];
        [self addSubview:self.img];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(12);
        make.top.equalTo(weakSelf).with.offset(17);
        make.height.mas_offset(20);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLab);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(9);
        
    }];
    [weakSelf.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLab);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(33);
        make.width.mas_offset(28);
        make.height.mas_offset(14);
    }];
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(64);
        make.height.mas_offset(65);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(14);
    }];
}


#pragma mark - getters

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.font = [UIFont systemFontOfSize:16];
        _topLab.textColor = [UIColor hexStringToColor:@"444444"];
        _topLab.text = @"免费精准报价";
    }
    return _topLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"10秒钟了解装修花多少钱";
        _contentLab.font = [UIFont systemFontOfSize:10];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab;
}

-(UIButton *)goBtn
{
    if(!_goBtn)
    {
        _goBtn = [[UIButton alloc] init];
        _goBtn.layer.masksToBounds = YES;
        _goBtn.layer.cornerRadius = 7;
        _goBtn.backgroundColor = [UIColor hexStringToColor:@"FF8830"];
        [_goBtn setTitle:@"GO>" forState:normal];
        _goBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_goBtn setTitleColor:White_Color forState:normal];
    }
    return _goBtn;
}

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"pic_jisuanqi"];
    }
    return _img;
}


@end
