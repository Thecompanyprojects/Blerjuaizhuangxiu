//
//  ApplydistributionCell4.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ApplydistributionCell4.h"

@interface ApplydistributionCell4()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UILabel *lab2;
@end

@implementation ApplydistributionCell4

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.btn0];
        [self.contentView addSubview:self.lab0];
        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.lab1];
        [self.contentView addSubview:self.btn2];
        [self.contentView addSubview:self.lab2];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(12);
        make.height.mas_offset(12);
    }];
    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
        make.height.mas_offset(14);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
    }];
    [weakSelf.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(80);
        make.height.mas_offset(14);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.btn0.mas_right).with.offset(10);
    }];
    [weakSelf.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(14);
        make.width.mas_offset(14);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.lab0.mas_right).with.offset(10);
    }];
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(14);
         make.width.mas_offset(80);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.btn1.mas_right).with.offset(10);
    }];
    [weakSelf.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(14);
        make.height.mas_offset(14);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.lab1.mas_right).with.offset(10);
    }];
    [weakSelf.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
         make.width.mas_offset(80);
        make.height.mas_offset(15);
        make.left.equalTo(weakSelf.btn2.mas_right).with.offset(10);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"xinxin0"];
    }
    return _leftImg;
}
-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setImage:[UIImage imageNamed:@"icon_jihuo"] forState:normal];
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}
-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}
-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
        [_btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}
-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.textColor = [UIColor hexStringToColor:@"333333"];
        _lab0.font = [UIFont systemFontOfSize:12];
        _lab0.text = @"对接人邀请码";
    }
    return _lab0;
}
-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textColor = [UIColor hexStringToColor:@"333333"];
        _lab1.font = [UIFont systemFontOfSize:12];
        _lab1.text = @"分销员邀请码";
    }
    return _lab1;
}
-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2.text = @"无";
        _lab2.textColor = [UIColor hexStringToColor:@"333333"];
        _lab2.font = [UIFont systemFontOfSize:12];
    }
    return _lab2;
}

#pragma mark - 实现方法

-(void)btn0click
{
    [self.btn0 setImage:[UIImage imageNamed:@"icon_jihuo"] forState:normal];
    [self.btn1 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
    [self.btn2 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
    [self.delegate choosecodetypebtn0];
}

-(void)btn1click
{
    [self.btn0 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
    [self.btn1 setImage:[UIImage imageNamed:@"icon_jihuo"] forState:normal];
    [self.btn2 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
    [self.delegate choosecodetypebtn1];
}

-(void)btn2click
{
    [self.btn0 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
    [self.btn1 setImage:[UIImage imageNamed:@"icon_weijihuo"] forState:normal];
    [self.btn2 setImage:[UIImage imageNamed:@"icon_jihuo"] forState:normal];
    [self.delegate choosecodetypebtn2];
}

@end
