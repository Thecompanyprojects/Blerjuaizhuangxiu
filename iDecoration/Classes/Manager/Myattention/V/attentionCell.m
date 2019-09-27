//
//  attentionCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "attentionCell.h"
#import <UIButton+LXMImagePosition.h>
#import "focusModel0.h"
#import "focusModel1.h"
#import "focusModel2.h"

@interface attentionCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *redLab;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;

@property (nonatomic,strong) UIImageView *vipImg0;
@property (nonatomic,strong) UIImageView *vipImg1;
@end

@implementation attentionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.redLab];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.btn0];
        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.btn2];
        [self.contentView addSubview:self.vipImg0];
        [self.contentView addSubview:self.vipImg1];
        [self setuplauout];
 
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(9);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(35);
        make.height.mas_offset(35);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(14);
        
    }];
    
    [weakSelf.vipImg0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLab);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
        make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(15);
    }];
    
    [weakSelf.vipImg1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.nameLab);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
        make.left.equalTo(weakSelf.vipImg0.mas_right).with.offset(5);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.iconImg.mas_bottom);
        make.left.equalTo(weakSelf.nameLab);
        make.width.mas_offset(200);
    }];
    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-13);
        make.width.mas_offset(38);
        make.height.mas_offset(20);
    }];
    
    [weakSelf.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-13);
        make.width.mas_offset(56);
        make.height.mas_offset(20);
    }];
    [weakSelf.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-13);
        make.width.mas_offset(60);
        make.height.mas_offset(20);
    }];
    [weakSelf.redLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg).with.offset(-4);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(-4);
        make.width.mas_offset(10);
        make.height.mas_offset(10);
    }];
}

#pragma mark - getters


-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 35/2;
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor hexStringToColor:@"000000"];
        _nameLab.text = @"华浔品味装饰";
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"华浔品味装饰是国内大型装饰...";
        _contentLab.textColor = [UIColor hexStringToColor:@"B6B4B4"];
        _contentLab.font = [UIFont systemFontOfSize:13];
    }
    return _contentLab;
}

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setTitle:@"关注" forState:normal];
        [_btn0 setImage:[UIImage imageNamed:@"guanzhu_jiahao"] forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:9];
        [_btn0 setTitleColor:[UIColor hexStringToColor:@"F4853A"] forState:normal];
        [_btn0 setImagePosition:LXMImagePositionLeft spacing:2];
        _btn0.layer.masksToBounds = YES;
        _btn0.layer.borderWidth = 0.5;
        _btn0.layer.borderColor = [UIColor hexStringToColor:@"F4853A"].CGColor;
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setTitle:@"已关注" forState:normal];
        [_btn1 setImage:[UIImage imageNamed:@"duigou_guanzhu"] forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:9];
        [_btn1 setTitleColor:[UIColor hexStringToColor:@"#B6B4B4"] forState:normal];
        [_btn1 setImagePosition:LXMImagePositionLeft spacing:2];
        _btn1.layer.masksToBounds = YES;
        _btn1.layer.borderWidth = 0.5;
        _btn1.layer.borderColor = [UIColor hexStringToColor:@"#B6B4B4"].CGColor;
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setTitle:@"互相关注" forState:normal];
        [_btn2 setImage:[UIImage imageNamed:@"jiaoliudenghao_gray"] forState:normal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:9];
        [_btn2 setTitleColor:[UIColor hexStringToColor:@"#B6B4B4"] forState:normal];
        [_btn2 setImagePosition:LXMImagePositionLeft spacing:2];
        _btn2.layer.masksToBounds = YES;
        _btn2.layer.borderWidth = 0.5;
        _btn2.layer.borderColor = [UIColor hexStringToColor:@"#B6B4B4"].CGColor;
        [_btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

-(UILabel *)redLab
{
    if(!_redLab)
    {
        _redLab = [[UILabel alloc] init];
        _redLab.backgroundColor = [UIColor redColor];
        _redLab.layer.masksToBounds = YES;
        _redLab.layer.cornerRadius = 5;
        _redLab.font = [UIFont systemFontOfSize:8];
        _redLab.textAlignment = NSTextAlignmentCenter;
        _redLab.textColor = [UIColor whiteColor];
    }
    return _redLab;
}

-(UIImageView *)vipImg0
{
    if(!_vipImg0)
    {
        _vipImg0 = [[UIImageView alloc] init];
        _vipImg0.image = [UIImage imageNamed:@"zhuanshi"];
    }
    return _vipImg0;
}


-(UIImageView *)vipImg1
{
    if(!_vipImg1)
    {
        _vipImg1 = [[UIImageView alloc] init];
        _vipImg1.image = [UIImage imageNamed:@"vip1"];
    }
    return _vipImg1;
}


-(void)setdata0:(focusModel0 *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.nameLab.text = model.companyName;
    self.contentLab.text = model.companyIntroduction;
    
    //[self.nameLab setSingleLineAutoResizeWithMaxWidth:(140)];
    
    
    if (model.appVip==1&&model.recommendVip==1) {
        self.vipImg0.image = [UIImage imageNamed:@"zhuanshi"];
        self.vipImg1.image = [UIImage imageNamed:@"vip1"];
        [self.vipImg0 setHidden:NO];
        [self.vipImg1 setHidden:NO];
    }
    else if (model.appVip==1&&model.recommendVip==0)
    {
        self.vipImg0.image = [UIImage imageNamed:@"vip1"];
        [self.vipImg0 setHidden:NO];
        [self.vipImg1 setHidden:YES];
    }
    else
    {
        [self.vipImg0 setHidden:YES];
        [self.vipImg1 setHidden:YES];
    }
    
    
    
   
    
    [self.btn0 setHidden:NO];
    [self.btn1 setHidden:YES];
    [self.btn2 setHidden:YES];
    [self.redLab setHidden:YES];
    
}

-(void)setdata1:(focusModel1 *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.nameLab.text = model.companyName;
    self.contentLab.text = model.companyIntroduction;
    if (model.messageNum>0) {
        [self.redLab setHidden:NO];
        self.redLab.text = [NSString stringWithFormat:@"%ld",model.messageNum];
    }
    else
    {
        [self.redLab setHidden:YES];
    }
    
    if (model.appVip==1&&model.recommendVip==1) {
        self.vipImg0.image = [UIImage imageNamed:@"zhuanshi"];
        self.vipImg1.image = [UIImage imageNamed:@"vip1"];
        [self.vipImg0 setHidden:NO];
        [self.vipImg1 setHidden:NO];
    }
    else if (model.appVip==1&&model.recommendVip==0)
    {
        self.vipImg0.image = [UIImage imageNamed:@"vip1"];
        [self.vipImg0 setHidden:NO];
        [self.vipImg1 setHidden:YES];
    }
    else
    {
        [self.vipImg0 setHidden:YES];
        [self.vipImg1 setHidden:YES];
    }
    
    [self.btn0 setHidden:YES];
    [self.btn1 setHidden:NO];
    [self.btn2 setHidden:YES];
   
}

-(void)setdata2:(focusModel2 *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.nameLab.text = model.trueName;
    self.contentLab.text = model.companyName;
    [self.btn1 setHidden:YES];
    [self.redLab setHidden:YES];
    
    if (model.attentionId==0) {
        [self.btn0 setHidden:NO];
        [self.btn2 setHidden:YES];
    }
    else
    {
        [self.btn0 setHidden:YES];
        [self.btn2 setHidden:NO];
    }
    if (model.appVip==1&&model.recommendVip==1) {
        self.vipImg0.image = [UIImage imageNamed:@"zhuanshi"];
        self.vipImg1.image = [UIImage imageNamed:@"vip1"];
        [self.vipImg0 setHidden:NO];
        [self.vipImg1 setHidden:NO];
    }
    else if (model.appVip==1&&model.recommendVip==0)
    {
        self.vipImg0.image = [UIImage imageNamed:@"vip1"];
        [self.vipImg0 setHidden:NO];
        [self.vipImg1 setHidden:YES];
    }
    else
    {
        [self.vipImg0 setHidden:YES];
        [self.vipImg1 setHidden:YES];
    }
  
}

-(void)btn0click
{
    [self.delegate myTabVClick0:self];
}

-(void)btn1click
{
    [self.delegate myTabVClick1:self];
}

-(void)btn2click
{
    [self.delegate myTabVClick2:self];
}

@end
