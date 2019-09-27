//
//  newapplylistCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newapplylistCell.h"

@interface newapplylistCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *agreedBtn;
@property (nonatomic,strong) UIButton *disagreedBtn;
@end

@implementation newapplylistCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.agreedBtn];
        [self.contentView addSubview:self.disagreedBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(45);
        make.height.mas_offset(45);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(9);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(15);
        make.height.mas_offset(20);
    }];
    [weakSelf.disagreedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(35);
        make.height.mas_offset(20);
        make.right.equalTo(weakSelf).with.offset(-9);
    }];
    [weakSelf.agreedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(35);
        make.height.mas_offset(20);
        make.right.equalTo(weakSelf.disagreedBtn.mas_left).with.offset(-15);
    }];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 45/2;
    }
    return _iconImg;
}


-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab;
}

-(UIButton *)agreedBtn
{
    if(!_agreedBtn)
    {
        _agreedBtn = [[UIButton alloc] init];
        [_agreedBtn addTarget:self action:@selector(disagreebtnclick) forControlEvents:UIControlEventTouchUpInside];
        _agreedBtn.backgroundColor = [UIColor hexStringToColor:@"24B764"];
        [_agreedBtn setTitle:@"确认" forState:normal];
        _agreedBtn.layer.masksToBounds = YES;
        _agreedBtn.layer.cornerRadius = 4;
        _agreedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_agreedBtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _agreedBtn;
}

-(UIButton *)disagreedBtn
{
    if(!_disagreedBtn)
    {
        _disagreedBtn = [[UIButton alloc] init];
        [_disagreedBtn addTarget:self action:@selector(disagreebtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_disagreedBtn setTitle:@"拒绝" forState:normal];
        _disagreedBtn.backgroundColor = [UIColor hexStringToColor:@"24B764"];
        _disagreedBtn.layer.masksToBounds = YES;
        _disagreedBtn.layer.cornerRadius = 4;
        _disagreedBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_disagreedBtn setTitleColor:[UIColor whiteColor] forState:normal];
    }
    return _disagreedBtn;
}


#pragma mark - 实现方法

-(void)agreedbtnclick
{
    [self.delegate myTabVClick1:self];
}

-(void)disagreebtnclick
{
    [self.delegate myTabVClick2:self];
}

@end
