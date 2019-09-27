//
//  myteamCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "myteamCell.h"
#import "myteamModel.h"

@interface myteamCell()

@end

@implementation myteamCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.typelab];
        [self.contentView addSubview:self.btn0];
        [self.contentView addSubview:self.btn1];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(24);
        make.width.mas_offset(34);
        make.height.mas_offset(34);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    [weakSelf.typelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-30);
        make.width.mas_offset(60);
    }];
    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-20);
        make.width.mas_offset(40);
        make.height.mas_offset(20);
    }];
    [weakSelf.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf.btn0.mas_left).with.offset(-10);
        make.width.mas_offset(40);
        make.height.mas_offset(20);
    }];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 34/2;
        _iconImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconimageclick)];
        [_iconImg addGestureRecognizer:singleTap];
    }
    return _iconImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor hexStringToColor:@"999999"];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.text = @"我是一级分销员";
        
    }
    return _nameLab;
}

-(UILabel *)typelab
{
    if(!_typelab)
    {
        _typelab = [[UILabel alloc] init];
        _typelab.font = [UIFont systemFontOfSize:12];
        _typelab.textAlignment = NSTextAlignmentRight;
    }
    return _typelab;
}


-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        _btn0.backgroundColor = Main_Color;
        _btn0.layer.masksToBounds = YES;
        _btn0.layer.cornerRadius = 4;
        _btn0.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btn0 setTitle:@"拒绝" forState:normal];
        [_btn0 setTitleColor:[UIColor whiteColor] forState:normal];
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:10];
        [_btn1 setTitle:@"确认" forState:normal];
        _btn1.layer.masksToBounds = YES;
        _btn1.layer.cornerRadius = 4;
        [_btn1 setTitleColor:[UIColor whiteColor] forState:normal];
        _btn1.backgroundColor = Main_Color;
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

#pragma mark - 点击方法

-(void)btn0click
{
    [self.delegate myTabVClick1:self];
}

-(void)btn1click
{
    [self.delegate myTabVClick2:self];
}

-(void)iconimageclick
{
    [self.delegate myTabVClick3:self];
}

@end
