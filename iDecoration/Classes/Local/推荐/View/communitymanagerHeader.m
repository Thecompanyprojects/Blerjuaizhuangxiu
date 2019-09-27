//
//  communitymanagerHeader.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "communitymanagerHeader.h"
#import "localcommunityModel.h"

@interface communitymanagerHeader()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;

@end

@implementation communitymanagerHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImg];
        [self addSubview:self.titleLab];
        [self addSubview:self.addressLab];
        [self addSubview:self.typeLab];
        [self addSubview:self.line0];
        [self addSubview:self.chooseleftBtn];
        [self addSubview:self.chooserightBtn];
        [self addSubview:self.line1];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(localcommunityModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.covermap]];
    self.titleLab.text = model.communityName;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",@"地址：",model.address];
    
    NSString *str0 = @"户型 ";
    NSString *str1 = [NSString stringWithFormat:@"%ld",model.mobelCount];
    NSString *str2 = @"案例 ";
    NSString *str3 = [NSString stringWithFormat:@"%ld",model.consCount];
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@",str0,str1,str2,str3];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"999999"]
                          range:NSMakeRange(0, str0.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"25B764"]
                          range:NSMakeRange(str0.length, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"999999"]
                          range:NSMakeRange(str0.length+str1.length, str2.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"25B764"]
                          range:NSMakeRange(str0.length+str1.length+str2.length, str3.length)];
    self.typeLab.attributedText = AttributedStr;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(7);
        //make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(12);
        make.width.mas_offset(112);
        make.height.mas_offset(70);
    }];
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(8);
        make.right.equalTo(weakSelf).with.offset(-10);
    }];
    [weakSelf.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(15);
    }];
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.addressLab.mas_bottom).with.offset(8);
    }];
    
    [weakSelf.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.leftImg.mas_bottom).with.offset(4);
        make.height.mas_offset(6);
    }];
    
    [weakSelf.chooseleftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.width.mas_offset(kSCREEN_WIDTH/2-4);
        make.height.mas_offset(43);
        make.top.equalTo(weakSelf.line0.mas_bottom);
    }];
    
    [weakSelf.chooserightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf);
        make.width.mas_offset(kSCREEN_WIDTH/2-4);
        make.height.mas_offset(43);
        make.top.equalTo(weakSelf.line0.mas_bottom);
    }];
    [weakSelf.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseleftBtn);
        make.bottom.equalTo(weakSelf.chooseleftBtn);
        make.width.mas_offset(5);
        make.height.mas_offset(43);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _titleLab;
}

-(UILabel *)addressLab
{
    if(!_addressLab)
    {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:12];
        _addressLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _addressLab;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        //        _typeLab.textColor = [UIColor hexStringToColor:@"999999"];
        _typeLab.font = [UIFont systemFontOfSize:12];
    }
    return _typeLab;
}

-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = kBackgroundColor;
    }
    return _line0;
}

-(UIButton *)chooseleftBtn
{
    if(!_chooseleftBtn)
    {
        _chooseleftBtn = [[UIButton alloc] init];
        [_chooseleftBtn setTitle:@"户型图" forState:normal];
        [_chooseleftBtn setTitleColor:[UIColor hexStringToColor:@"FF0000"] forState:normal];
        _chooseleftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chooseleftBtn addTarget:self action:@selector(chooseleftbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseleftBtn;
}


-(UIButton *)chooserightBtn
{
    if(!_chooserightBtn)
    {
        _chooserightBtn = [[UIButton alloc] init];
        [_chooserightBtn setTitle:@"工地列表" forState:normal];
        [_chooserightBtn setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _chooserightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_chooserightBtn addTarget:self action:@selector(chooserightbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooserightBtn;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = kBackgroundColor;
    }
    return _line1;
}

-(void)chooseleftbtnclick
{
     [_chooseleftBtn setTitleColor:[UIColor hexStringToColor:@"FF0000"] forState:normal];
     [_chooserightBtn setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
}

-(void)chooserightbtnclick
{
    [_chooseleftBtn setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [_chooserightBtn setTitleColor:[UIColor hexStringToColor:@"FF0000"] forState:normal];
}



@end
