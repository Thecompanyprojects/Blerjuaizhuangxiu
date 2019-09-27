//
//  newpopviewCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newpopviewCell.h"
#import "AdviserList.h"

@interface newpopviewCell()
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *contentLab2;
@property (nonatomic,strong) UIImageView *cardImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIImageView *phoneImg;
@property (nonatomic,strong) UIImageView *wxImg;
@property (nonatomic,strong) UIImageView *qqImg;

@end

@implementation newpopviewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLab];
        [self addSubview:self.contentLab];
        [self addSubview:self.contentLab2];
        [self addSubview:self.cardImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.phoneImg];
        [self addSubview:self.phoneLab];
        [self addSubview:self.wxImg];
        [self addSubview:self.wxLab];
        [self addSubview:self.qqImg];
        [self addSubview:self.qqLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(AdviserList *)model
{
    self.nameLab.text = model.adviserName;
    self.phoneLab.text = model.adviserPhone;
    self.wxLab.text = model.adviserWx;
    self.qqLab.text = model.adviserQq;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(24);
        make.width.mas_offset(125);
        make.height.mas_offset(27);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(17);
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.contentLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(9);
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.cardImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(14);
        make.height.mas_offset(13);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.contentLab2.mas_bottom).with.offset(7);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.cardImg.mas_bottom).with.offset(3);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(11);
        make.width.mas_offset(13);
        make.height.mas_offset(13);
    }];
    [weakSelf.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.phoneImg.mas_bottom).with.offset(3);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.wxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.phoneLab.mas_bottom).with.offset(11);
        make.width.mas_offset(13);
        make.height.mas_offset(13);
    }];
    [weakSelf.wxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.wxImg.mas_bottom).with.offset(3);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.qqImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.wxLab.mas_bottom).with.offset(11);
        make.width.mas_offset(13);
        make.height.mas_offset(13);
    }];
    [weakSelf.qqLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.qqImg.mas_bottom).with.offset(3);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
}

#pragma mark - getters

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.textColor = [UIColor whiteColor];
        _topLab.backgroundColor = [UIColor orangeColor];
        _topLab.text = @"专属顾问";
        _topLab.font = [UIFont systemFontOfSize:14];
        _topLab.layer.masksToBounds = YES;
        _topLab.layer.cornerRadius = 27/2;
        _topLab.userInteractionEnabled=YES;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside)];
        [_topLab addGestureRecognizer:labelTapGestureRecognizer];
    }
    return _topLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:10];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
        _contentLab.text = @"此订单来自同城，需申请同城服务后才可以查看";
    }
    return _contentLab;
}

-(UILabel *)contentLab2
{
    if(!_contentLab2)
    {
        _contentLab2 = [[UILabel alloc] init];
        _contentLab2.textAlignment = NSTextAlignmentCenter;
        _contentLab2.font = [UIFont systemFontOfSize:10];
        _contentLab2.textColor = [UIColor hexStringToColor:@"999999"];
        _contentLab2.text = @"详情请咨询您的专属顾问 ";
    }
    return _contentLab2;
}


-(UIImageView *)cardImg
{
    if(!_cardImg)
    {
        _cardImg = [[UIImageView alloc] init];
        _cardImg.image = [UIImage imageNamed:@"icon_mingpian_mingpian"];
    }
    return _cardImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:11];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
        _nameLab.text = @"李三思";
    }
    return _nameLab;
}

-(UIImageView *)phoneImg
{
    if(!_phoneImg)
    {
        _phoneImg = [[UIImageView alloc] init];
        _phoneImg.image = [UIImage imageNamed:@"icon_dianhua_dianhua"];
        _phoneImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside1)];
        [_phoneImg addGestureRecognizer:tap2];
    }
    return _phoneImg;
}

-(UILabel *)phoneLab
{
    if(!_phoneLab)
    {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.textAlignment = NSTextAlignmentCenter;
        _phoneLab.font = [UIFont systemFontOfSize:11];
        _phoneLab.textColor = [UIColor hexStringToColor:@"333333"];
        _phoneLab.text = @"13522249020";
        _phoneLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneclick)];
        [_phoneLab addGestureRecognizer:tap2];
    }
    return _phoneLab;
}

-(UIImageView *)wxImg
{
    if(!_wxImg)
    {
        _wxImg = [[UIImageView alloc] init];
        _wxImg.image = [UIImage imageNamed:@"icon_weixin_weixn"];
        _wxImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside2)];
        [_wxImg addGestureRecognizer:tap2];
    }
    return _wxImg;
}

-(UILabel *)wxLab
{
    if(!_wxLab)
    {
        _wxLab = [[UILabel alloc] init];
        _wxLab.textAlignment = NSTextAlignmentCenter;
        _wxLab.font = [UIFont systemFontOfSize:11];
        _wxLab.textColor = [UIColor hexStringToColor:@"333333"];
        _wxLab.text = @"13522249020";
        _wxLab.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxclick)];
        [_wxLab addGestureRecognizer:tap1];
       
    }
    return _wxLab;
}

-(UIImageView *)qqImg
{
    if(!_qqImg)
    {
        _qqImg = [[UIImageView alloc] init];
        _qqImg.image = [UIImage imageNamed:@"icon_qq_qq"];
        _qqImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside3)];
        [_qqImg addGestureRecognizer:tap2];
    }
    return _qqImg;
}

-(UILabel *)qqLab
{
    if(!_qqLab)
    {
        _qqLab = [[UILabel alloc] init];
        _qqLab.textAlignment = NSTextAlignmentCenter;
        _qqLab.font = [UIFont systemFontOfSize:11];
        _qqLab.textColor = [UIColor hexStringToColor:@"333333"];
        _qqLab.text = @"13522249020";
        _qqLab.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqclick)];
        [_qqLab addGestureRecognizer:tap];
      
    }
    return _qqLab;
}

#pragma mark - 实现方法

-(void)labelTouchUpInside
{
    [self.delegate phoneTabVClick:self];
}

-(void)phoneclick
{
    [self.delegate phoneTabVClick:self];
}

-(void)wxclick
{
    [self.delegate wxTabVClick:self];
}

-(void)qqclick
{
    [self.delegate qqTabVClick:self];
}

-(void)labelTouchUpInside1
{
    [self.delegate phoneTabVClick:self];
}

-(void)labelTouchUpInside2
{
    [self.delegate wxTabVClick:self];
}

-(void)labelTouchUpInside3
{
    [self.delegate qqTabVClick:self];
}

@end
