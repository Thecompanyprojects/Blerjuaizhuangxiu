//
//  localstylechangeCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localstylechangeCell0.h"

@interface localstylechangeCell0()
@property (nonatomic,strong) UIImageView *boyImg;
@property (nonatomic,strong) UIImageView *girlImg;
@property (nonatomic,strong) UILabel *topLab;


@end

@implementation localstylechangeCell0

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.topLab];
        [self.contentView addSubview:self.boyImg];
        [self.contentView addSubview:self.girlImg];
        [self.contentView addSubview:self.chooseboyBtn];
        [self.contentView addSubview:self.choosegiryBtn];
        [self.contentView addSubview:self.submitBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(61);
    }];
    [weakSelf.boyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(65);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(48);
        make.width.mas_offset(81);
        make.height.mas_offset(101);
    }];
    [weakSelf.girlImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-65);
        make.top.equalTo(weakSelf.boyImg);
        make.width.mas_offset(81);
        make.height.mas_offset(101);
    }];
    [weakSelf.chooseboyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(94);
        make.top.equalTo(weakSelf.boyImg.mas_bottom).with.offset(18);
        make.width.mas_offset(23);
        make.height.mas_offset(23);
    }];
    [weakSelf.choosegiryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-94);
        make.top.equalTo(weakSelf.chooseboyBtn);
        make.width.mas_offset(23);
        make.height.mas_offset(23);
    }];
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseboyBtn.mas_bottom).with.offset(63);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(237);
        make.height.mas_offset(48);
    }];
}

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.numberOfLines = 2;
        _topLab.text = @"选择你的性别/爱装修将根据您的性别来测试";
        _topLab.font = [UIFont systemFontOfSize:16];
        _topLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _topLab;
}


#pragma mark - getters

-(UIImageView *)boyImg
{
    if(!_boyImg)
    {
        _boyImg = [[UIImageView alloc] init];
        _boyImg.image = [UIImage imageNamed:@"localstylexinbie1"];
    }
    return _boyImg;
}

-(UIImageView *)girlImg
{
    if(!_girlImg)
    {
        _girlImg = [[UIImageView alloc] init];
        _girlImg.image = [UIImage imageNamed:@"localstylexinbie2"];
    }
    return _girlImg;
}

-(UIButton *)chooseboyBtn
{
    if(!_chooseboyBtn)
    {
        _chooseboyBtn = [[UIButton alloc] init];
        [_chooseboyBtn setImage:[UIImage imageNamed:@"icon_duigou_jihuo"] forState:normal];
    }
    return _chooseboyBtn;
}

-(UIButton *)choosegiryBtn
{
    if(!_choosegiryBtn)
    {
        _choosegiryBtn = [[UIButton alloc] init];
        [_choosegiryBtn setImage:[UIImage imageNamed:@"icon_duigou"] forState:normal];
    }
    return _choosegiryBtn;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = [UIColor hexStringToColor:@"25B764"];
        [_submitBtn setTitleColor:White_Color forState:normal];
        [_submitBtn setTitle:@"下一步" forState:normal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 3;
    }
    return _submitBtn;
}








@end
