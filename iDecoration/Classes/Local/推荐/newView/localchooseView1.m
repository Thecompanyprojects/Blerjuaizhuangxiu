//
//  localchooseView1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localchooseView1.h"

@implementation localchooseView1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.goBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf).with.offset(17);
        
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLab);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(9);
    }];
    [weakSelf.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(28);
        make.height.mas_offset(14);
        make.top.equalTo(weakSelf).with.offset(17);
        make.right.equalTo(weakSelf).with.offset(-10);
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
    }
    return _topLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor hexStringToColor:@"777777"];
        _contentLab.font = [UIFont systemFontOfSize:10];
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




@end
