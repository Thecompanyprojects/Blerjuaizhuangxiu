//
//  DistributionbindingCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionbindingCell0.h"

@interface DistributionbindingCell0()

@property (nonatomic,strong) UIButton *wxImg;
@property (nonatomic,strong) UIButton *zhifuImg;
@property (nonatomic,strong) UILabel *wxLab;
@property (nonatomic,strong) UILabel *zhifuLab;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,copy)   NSString *tagstr;
@end

@implementation DistributionbindingCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.tagstr = @"0";
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.wxImg];
        [self.contentView addSubview:self.zhifuImg];
        //[self.contentView addSubview:self.bankImg];
        [self.contentView addSubview:self.wxLab];
        [self.contentView addSubview:self.zhifuLab];
       // [self.contentView addSubview:self.bankLab];
        [self.contentView addSubview:self.line];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14*WIDTH_SCALE);
        make.top.equalTo(weakSelf).with.offset(12);
        make.right.equalTo(weakSelf).with.offset(-9);
        make.height.mas_offset(15);
    }];
    
    [weakSelf.zhifuImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(36*WIDTH_SCALE);
        make.top.equalTo(weakSelf).with.offset(34*WIDTH_SCALE);
        make.width.mas_offset(30*WIDTH_SCALE);
        make.height.mas_offset(30*WIDTH_SCALE);
    }];
    [weakSelf.zhifuLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.zhifuImg.mas_left).with.offset(-5);
        make.top.equalTo(weakSelf.zhifuImg.mas_bottom).with.offset(4*HEIGHT_SCALE);
        make.right.equalTo(weakSelf.zhifuImg.mas_right).with.offset(5);
        
    }];
    
    [weakSelf.wxImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.zhifuImg.mas_right).with.offset(36);
        make.top.equalTo(weakSelf.zhifuImg);
        make.width.mas_offset(30*WIDTH_SCALE);
        make.height.mas_offset(30*WIDTH_SCALE);
    }];
    [weakSelf.wxLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.wxImg);
        make.right.equalTo(weakSelf.wxImg);
        make.top.equalTo(weakSelf.zhifuLab);
    }];
   
//    [weakSelf.bankImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.wxImg.mas_right).with.offset(36);
//        make.top.equalTo(weakSelf.zhifuImg);
//        make.width.mas_offset(30*WIDTH_SCALE);
//        make.height.mas_offset(30*WIDTH_SCALE);
//    }];
//    [weakSelf.bankLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.bankImg).with.offset(-5);
//        make.right.equalTo(weakSelf.bankImg).with.offset(5);
//        make.top.equalTo(weakSelf.zhifuLab);
//    }];
    self.line.frame = CGRectMake(35*WIDTH_SCALE, 90, 30*WIDTH_SCALE, 2);
}

#pragma mark - getters

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor hexStringToColor:@"919090"];
        
    }
    return _contentLab;
}


-(UIButton *)wxImg
{
    if(!_wxImg)
    {
        _wxImg = [[UIButton alloc] init];
        [_wxImg setImage:[UIImage imageNamed:@"icon_weixin"] forState:normal];
        [_wxImg addTarget:self action:@selector(wxbtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_wxImg setHidden:YES];
    }
    return _wxImg;
}


-(UIButton *)zhifuImg
{
    if(!_zhifuImg)
    {
        _zhifuImg = [[UIButton alloc] init];
        [_zhifuImg setImage:[UIImage imageNamed:@"icon_zhifubao"] forState:normal];
        [_zhifuImg addTarget:self action:@selector(zhifubaobtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhifuImg;
}

//-(UIButton *)bankImg
//{
//    if(!_bankImg)
//    {
//        _bankImg = [[UIButton alloc] init];
//        [_bankImg setImage:[UIImage imageNamed:@"icon_yhank"] forState:normal];
//        [_bankImg addTarget:self action:@selector(bankbtnclick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _bankImg;
//}


-(UILabel *)wxLab
{
    if(!_wxLab)
    {
        _wxLab = [[UILabel alloc] init];
        _wxLab.textAlignment = NSTextAlignmentCenter;
        _wxLab.text = @"微信";
        _wxLab.font = [UIFont systemFontOfSize:12];
        _wxLab.textColor = [UIColor hexStringToColor:@"919090"];
        [_wxLab setHidden:YES];
    }
    return _wxLab;
}

-(UILabel *)zhifuLab
{
    if(!_zhifuLab)
    {
        _zhifuLab = [[UILabel alloc] init];
        _zhifuLab.textAlignment = NSTextAlignmentCenter;
        _zhifuLab.text = @"支付宝";
        _zhifuLab.font = [UIFont systemFontOfSize:12];
        _zhifuLab.textColor = [UIColor hexStringToColor:@"919090"];
    }
    return _zhifuLab;
}

//-(UILabel *)bankLab
//{
//    if(!_bankLab)
//    {
//        _bankLab = [[UILabel alloc] init];
//        _bankLab.textAlignment = NSTextAlignmentCenter;
//        _bankLab.text = @"银行卡";
//        _bankLab.font = [UIFont systemFontOfSize:12];
//        _bankLab.textColor = [UIColor hexStringToColor:@"919090"];
//    }
//    return _bankLab;
//}


-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"#1F9FDB"];
        [_line setHidden:YES];
    }
    return _line;
}

#pragma mark - 实现方法

-(void)zhifubaobtnclick
{
    self.tagstr = @"0";
    self.line.frame = CGRectMake(35*WIDTH_SCALE, 90, 30*WIDTH_SCALE, 2);
    [self.delegate myTabVClick:self andtagstr:self.tagstr];
}

-(void)wxbtnclick
{
    self.tagstr = @"1";
    self.line.frame = CGRectMake(98*WIDTH_SCALE, 90, 30*WIDTH_SCALE, 2);
    [self.delegate myTabVClick:self andtagstr:self.tagstr];
}

@end
