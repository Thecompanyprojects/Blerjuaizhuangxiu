//
//  addcommunityCell3.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "addcommunityCell3.h"

@interface addcommunityCell3()

@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UILabel *lab2;
@property (nonatomic,strong) UILabel *lab3;

@end

@implementation addcommunityCell3

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.lab0];
        [self.contentView addSubview:self.text0];
        [self.contentView addSubview:self.lab1];
        [self.contentView addSubview:self.text1];
        [self.contentView addSubview:self.lab2];
        [self.contentView addSubview:self.text2];
        [self.contentView addSubview:self.lab3];
        [self.contentView addSubview:self.text3];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(80);
        make.centerY.equalTo(weakSelf);
        //make.top.equalTo(weakSelf).with.offset(12);
    }];
    [weakSelf.text0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    [weakSelf.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.text0.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    
    [weakSelf.text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab0.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.text1.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    
    [weakSelf.text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab1.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    [weakSelf.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.text2.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    
    [weakSelf.text3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab2.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
    [weakSelf.lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.text3.mas_right).with.offset(8);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(14);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = [UIColor hexStringToColor:@"333333"];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.text = @"户型类型";
    }
    return _leftLab;
}

-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.textAlignment = NSTextAlignmentCenter;
        _lab0.font = [UIFont systemFontOfSize:14];
        _lab0.textColor = [UIColor hexStringToColor:@"999999"];
        _lab0.text = @"室";
    }
    return _lab0;
}

-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.font = [UIFont systemFontOfSize:14];
        _lab1.textColor = [UIColor hexStringToColor:@"999999"];
        _lab1.text = @"厅";
    }
    return _lab1;
}

-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2.textAlignment = NSTextAlignmentCenter;
        _lab2.font = [UIFont systemFontOfSize:14];
        _lab2.textColor = [UIColor hexStringToColor:@"999999"];
        _lab2.text = @"卫";
    }
    return _lab2;
}

-(UILabel *)lab3
{
    if(!_lab3)
    {
        _lab3 = [[UILabel alloc] init];
        _lab3.textAlignment = NSTextAlignmentCenter;
        _lab3.font = [UIFont systemFontOfSize:14];
        _lab3.textColor = [UIColor hexStringToColor:@"999999"];
        _lab3.text = @"厨";
    }
    return _lab3;
}

-(UITextField *)text0
{
    if(!_text0)
    {
        _text0 = [[UITextField alloc] init];
        _text0.keyboardType = UIKeyboardTypeNumberPad;
        _text0.font = [UIFont systemFontOfSize:12];
    }
    return _text0;
}

-(UITextField *)text1
{
    if(!_text1)
    {
        _text1 = [[UITextField alloc] init];
        _text1.keyboardType = UIKeyboardTypeNumberPad;
        _text1.font = [UIFont systemFontOfSize:12];
    }
    return _text1;
}

-(UITextField *)text2
{
    if(!_text2)
    {
        _text2 = [[UITextField alloc] init];
        _text2.keyboardType = UIKeyboardTypeNumberPad;
        _text2.font = [UIFont systemFontOfSize:12];
    }
    return _text2;
}

-(UITextField *)text3
{
    if(!_text3)
    {
        _text3 = [[UITextField alloc] init];
        _text3.keyboardType = UIKeyboardTypeNumberPad;
        _text3.font = [UIFont systemFontOfSize:12];
    }
    return _text3;
}








@end
