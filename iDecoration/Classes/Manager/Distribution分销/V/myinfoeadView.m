//
//  myinfoeadView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "myinfoeadView.h"

@interface myinfoeadView()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UILabel *leftLab0;
@property (nonatomic,strong) UILabel *contentLab0;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UILabel *leftLab1;
@property (nonatomic,strong) UILabel *contentLab1;

@property (nonatomic,strong) UILabel *leftLab2;
@property (nonatomic,strong) UILabel *contentLab2;
@property (nonatomic,strong) UIView *line2;

@property (nonatomic,strong) UILabel *leftLab3;
@property (nonatomic,strong) UILabel *contentLab3;
@property (nonatomic,strong) UIView *line3;

@end

@implementation myinfoeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.line0];
        [self addSubview:self.leftLab0];
        [self addSubview:self.contentLab0];
        
//        [self addSubview:self.line1];
//        [self addSubview:self.leftLab1];
//        [self addSubview:self.contentLab1];
       
        [self addSubview:self.leftLab2];
        [self addSubview:self.contentLab2];
        [self addSubview:self.line2];
        [self addSubview:self.leftLab3];
        [self addSubview:self.contentLab3];
        [self addSubview:self.line3];
        [self addSubview:self.topLab];
        [self addSubview:self.leftImg];
        [self addSubview:self.rightImg];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(45);
        make.height.mas_offset(45);
        make.top.equalTo(weakSelf).with.offset(10);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
        
    }];
    
    [weakSelf.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.iconImg.mas_bottom).with.offset(10);
    }];
    
    [weakSelf.leftLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line0).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(80);
    }];
    
    [weakSelf.contentLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.line0).with.offset(10);
        make.left.equalTo(weakSelf.leftLab0.mas_right);
    }];
    
//    [weakSelf.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf);
//        make.left.equalTo(weakSelf).with.offset(14);
//        make.height.mas_offset(1);
//        make.top.equalTo(weakSelf.leftLab0.mas_bottom).with.offset(10);
//    }];
//
//    [weakSelf.leftLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.line1).with.offset(10);
//        make.left.equalTo(weakSelf).with.offset(14);
//        make.width.mas_offset(80);
//    }];
//
//    [weakSelf.contentLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(weakSelf).with.offset(-14);
//        make.top.equalTo(weakSelf.line1).with.offset(10);
//        make.left.equalTo(weakSelf.leftLab1.mas_right);
//    }];
    
    [weakSelf.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.leftLab0.mas_bottom).with.offset(10);
    }];
   
    [weakSelf.leftLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line2).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(80);
    }];
    
    [weakSelf.contentLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.line2).with.offset(10);
        make.left.equalTo(weakSelf.leftLab2.mas_right);
    }];
    
    [weakSelf.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.leftLab2.mas_bottom).with.offset(10);
    }];
    [weakSelf.leftLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.line3).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(80);
    }];
    [weakSelf.contentLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.line3).with.offset(10);
        make.left.equalTo(weakSelf.leftLab3.mas_right);
    }];

    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLab3.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(18);
    }];
    
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(150);
        make.height.mas_offset(104);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(20);
        make.left.equalTo(weakSelf).with.offset(25);
    }];
    
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(150);
        make.height.mas_offset(104);
        make.top.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf).with.offset(25);
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


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor hexStringToColor:@"3F3F3F"];
    }
    return _nameLab;
}


-(UILabel *)leftLab0
{
    if(!_leftLab0)
    {
        _leftLab0 = [[UILabel alloc] init];
        _leftLab0.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _leftLab0.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab0;
}

-(UILabel *)contentLab0
{
    if(!_contentLab0)
    {
        _contentLab0 = [[UILabel alloc] init];
        _contentLab0.font = [UIFont systemFontOfSize:14];
        _contentLab0.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab0;
}

-(UILabel *)leftLab1
{
    if(!_leftLab1)
    {
        _leftLab1 = [[UILabel alloc] init];
        _leftLab1.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _leftLab1.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab1;
}

-(UILabel *)contentLab1
{
    if(!_contentLab1)
    {
        _contentLab1 = [[UILabel alloc] init];
        _contentLab1.font = [UIFont systemFontOfSize:14];
        _contentLab1.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab1;
}


-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = [UIColor hexStringToColor:@"F5F5F5"];
    }
    return _line0;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor hexStringToColor:@"F5F5F5"];
    }
    return _line1;
}


-(UILabel *)leftLab2
{
    if(!_leftLab2)
    {
        _leftLab2 = [[UILabel alloc] init];
        _leftLab2.text = @"手机号码";
        _leftLab2.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _leftLab2.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab2;
}


-(UILabel *)contentLab2
{
    if(!_contentLab2)
    {
        _contentLab2 = [[UILabel alloc] init];
        _contentLab2.font = [UIFont systemFontOfSize:14];
        _contentLab2.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab2;
}


-(UIView *)line2
{
    if(!_line2)
    {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor hexStringToColor:@"F5F5F5"];
    }
    return _line2;
}

-(UILabel *)leftLab3
{
    if(!_leftLab3)
    {
        _leftLab3 = [[UILabel alloc] init];
        _leftLab3.text = @"所在城市";
        _leftLab3.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _leftLab3.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab3;
}

-(UILabel *)contentLab3
{
    if(!_contentLab3)
    {
        _contentLab3 = [[UILabel alloc] init];
        _contentLab3.font = [UIFont systemFontOfSize:14];
        _contentLab3.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab3;
}
-(UIView *)line3
{
    if(!_line3)
    {
        _line3 = [[UIView alloc] init];
        _line3.backgroundColor = [UIColor hexStringToColor:@"F5F5F5"];
    }
    return _line3;
}


-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.font = [UIFont systemFontOfSize:14];
        
        _topLab.textColor = [UIColor hexStringToColor:@"3F3F3F"];
    }
    return _topLab;
}


-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}


-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        
    }
    return _rightImg;
}

-(void)setdata:(NSDictionary *)dic
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo"]]];
    self.nameLab.text = [dic objectForKey:@"trueName"];
    self.leftLab0.text = @"微信号";
    self.contentLab0.text = [dic objectForKey:@"weixin"];
    self.leftLab1.text = @"身份证号码";
    self.contentLab1.text = [dic objectForKey:@"idCard"];
    self.contentLab2.text = [dic objectForKey:@"phone"];
    self.contentLab3.text = [dic objectForKey:@"spreadArea"];
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"idCardImg"]]];
    [self.rightImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"idCardPhoto"]]];
}

@end
