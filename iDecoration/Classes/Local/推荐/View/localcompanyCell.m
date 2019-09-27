//
//  localcompanyCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localcompanyCell.h"
#import <SDAutoLayout.h>
#import "localcompanyModel.h"

@interface localcompanyCell()
@property (nonatomic,strong) UIImageView *logoimg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *vip0;
@property (nonatomic,strong) UIImageView *vip1;
@property (nonatomic,strong) UILabel *zuojilab;
@property (nonatomic,strong) UIButton *phoneBtn;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *guanzhuImg;
@end

@implementation localcompanyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.logoimg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.vip0];
        [self.contentView addSubview:self.vip1];
        [self.contentView addSubview:self.zuojilab];
        [self.contentView addSubview:self.phoneBtn];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.guanzhuImg];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(localcompanyModel *)model
{
    [self.logoimg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    
    if ([model.authenticationId isEqualToString:@"0"]) {
        [self.guanzhuImg setHidden:YES];
    }
    else
    {
        [self.guanzhuImg setHidden:NO];
    }
    
    if (model.companyName.length>8) {
        NSString *subString1 = [model.companyName substringToIndex:7];
        NSString *subString2 = @"...";
        NSString *str = [subString1 stringByAppendingString:subString2];

        self.nameLab.text = str;
    }
    else
    {
        self.nameLab.text = model.companyName;
    }
    if (model.appVip==1) {
        [self.vip0 setHidden:NO];
    }
    else
    {
        [self.vip0 setHidden:YES];
    }
    if (model.svip==1) {
        [self.vip1 setHidden:NO];
    }
    else
    {
        [self.vip1 setHidden:YES];
    }
    self.zuojilab.text = [NSString stringWithFormat:@"%@%@",@"简介：",model.companyIntroduction?:@""];
    self.contentLab.text = [NSString stringWithFormat:@"%@%@",model.companyAddress?:@"",model.locationStr?:@""];
    [self updateLayout];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    weakSelf.logoimg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 14)
    .heightIs(60)
    .widthIs(60);
    
    weakSelf.nameLab
    .sd_layout
    .leftSpaceToView(weakSelf.logoimg, 14)
    .topEqualToView(weakSelf.logoimg)
    .autoHeightRatio(0);
    
    
    [weakSelf.nameLab setMaxNumberOfLinesToShow:1];
    [weakSelf.nameLab setSingleLineAutoResizeWithMaxWidth:(240)];
    
    weakSelf.vip0
    .sd_layout
    .leftSpaceToView(weakSelf.nameLab, 12)
    .centerYEqualToView(weakSelf.nameLab)
    .widthIs(16)
    .heightIs(16);
    
    weakSelf.vip1
    .sd_layout
    .leftSpaceToView(weakSelf.vip0, 6)
    .centerYEqualToView(weakSelf.nameLab)
    .widthIs(16)
    .heightIs(16);
    
    weakSelf.zuojilab
    .sd_layout
    .leftEqualToView(weakSelf.nameLab)
    .topSpaceToView(weakSelf.nameLab, 10)
    .rightSpaceToView(weakSelf.contentView,14)
    .autoHeightRatio(0);
    
    [self.zuojilab setMaxNumberOfLinesToShow:2];

    weakSelf.phoneBtn
    .sd_layout
    .leftSpaceToView(weakSelf.zuojilab, 15)
    .topEqualToView(weakSelf.zuojilab)
    .heightIs(15)
    .rightSpaceToView(weakSelf.contentView, 20);
    
    weakSelf.contentLab
    .sd_layout
    .leftEqualToView(weakSelf.nameLab)
    .topSpaceToView(weakSelf.zuojilab, 10)
    .rightSpaceToView(weakSelf.contentView, 14)
    .autoHeightRatio(0);
    
    weakSelf.guanzhuImg
    .sd_layout
    .rightEqualToView(weakSelf.logoimg)
    .topEqualToView(weakSelf.logoimg)
    .widthIs(36)
    .heightIs(36);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.contentLab bottomMargin:14];
}

#pragma mark - getters

-(UIImageView *)logoimg
{
    if(!_logoimg)
    {
        _logoimg = [[UIImageView alloc] init];
        
    }
    return _logoimg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:13];
    }
    return _nameLab;
}

-(UIImageView *)vip0
{
    if(!_vip0)
    {
        _vip0 = [[UIImageView alloc] init];
        _vip0.image = [UIImage imageNamed:@"vip1"];
    }
    return _vip0;
}

-(UIImageView *)vip1
{
    if(!_vip1)
    {
        _vip1 = [[UIImageView alloc] init];
        _vip1.image = [UIImage imageNamed:@"zhuanshi"];
    }
    return _vip1;
}

-(UILabel *)zuojilab
{
    if(!_zuojilab)
    {
        _zuojilab = [[UILabel alloc] init];
        _zuojilab.font = [UIFont systemFontOfSize:12];
        _zuojilab.textColor = [UIColor darkGrayColor];
        
    }
    return _zuojilab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:11];
    }
    return _contentLab;
}

-(UIButton *)phoneBtn
{
    if(!_phoneBtn)
    {
        _phoneBtn = [[UIButton alloc] init];
        _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_phoneBtn setTitleColor:[UIColor hexStringToColor:@"505BF7"] forState:normal];
        [_phoneBtn addTarget:self action:@selector(phonebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

-(UIImageView *)guanzhuImg
{
    if(!_guanzhuImg)
    {
        _guanzhuImg = [[UIImageView alloc] init];
        _guanzhuImg.image = [UIImage imageNamed:@"renzheng_local"];
    }
    return _guanzhuImg;
}

#pragma mark - 协议方法

-(void)phonebtnclick
{
    [self.delegate myphoneVClick:self];
}

@end
