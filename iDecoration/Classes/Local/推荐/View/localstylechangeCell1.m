//
//  localstylechangeCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localstylechangeCell1.h"

@interface localstylechangeCell1()
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UIButton *chooseBtn0;
@property (nonatomic,strong) UIButton *chooseBtn1;
@property (nonatomic,strong) UIButton *chooseBtn2;
@end

@implementation localstylechangeCell1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.topLab];
        [self.contentView addSubview:self.chooseBtn0];
        [self.contentView addSubview:self.chooseBtn1];
        [self.contentView addSubview:self.chooseBtn2];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(77);
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.chooseBtn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(214);
        make.height.mas_offset(49);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(57);
    }];
    [weakSelf.chooseBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseBtn0.mas_bottom).with.offset(31);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(214);
        make.height.mas_offset(49);
    }];
    [weakSelf.chooseBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseBtn1.mas_bottom).with.offset(31);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(214);
        make.height.mas_offset(49);
    }];
}

#pragma mark - getters

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.font = [UIFont systemFontOfSize:22];
        _topLab.textColor = [UIColor hexStringToColor:@"333333"];
        _topLab.text = @"你的年龄？";
    }
    return _topLab;
}

-(UIButton *)chooseBtn0
{
    if(!_chooseBtn0)
    {
        _chooseBtn0 = [[UIButton alloc] init];
        [_chooseBtn0 setTitle:@"30岁以下" forState:normal];
        [_chooseBtn0 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _chooseBtn0.titleLabel.font = [UIFont systemFontOfSize:18];
        _chooseBtn0.layer.masksToBounds = YES;
        _chooseBtn0.layer.cornerRadius = 24;
        _chooseBtn0.layer.borderColor = [UIColor hexStringToColor:@"25B764"].CGColor;
        _chooseBtn0.layer.borderWidth = 1;
    }
    return _chooseBtn0;
}

-(UIButton *)chooseBtn1
{
    if(!_chooseBtn1)
    {
        _chooseBtn1 = [[UIButton alloc] init];
        [_chooseBtn1 setTitle:@"30-45岁" forState:normal];
        [_chooseBtn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _chooseBtn1.titleLabel.font = [UIFont systemFontOfSize:18];
        _chooseBtn1.layer.masksToBounds = YES;
        _chooseBtn1.layer.cornerRadius = 24;
        _chooseBtn1.layer.borderColor = [UIColor hexStringToColor:@"25B764"].CGColor;
        _chooseBtn1.layer.borderWidth = 1;
    }
    return _chooseBtn1;
}

-(UIButton *)chooseBtn2
{
    if(!_chooseBtn2)
    {
        _chooseBtn2 = [[UIButton alloc] init];
        [_chooseBtn2 setTitle:@"45岁以上" forState:normal];
        [_chooseBtn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _chooseBtn2.titleLabel.font = [UIFont systemFontOfSize:18];
        _chooseBtn2.layer.masksToBounds = YES;
        _chooseBtn2.layer.cornerRadius = 24;
        _chooseBtn2.layer.borderColor = [UIColor hexStringToColor:@"25B764"].CGColor;
        _chooseBtn2.layer.borderWidth = 1;
    }
    return _chooseBtn2;
}





@end
