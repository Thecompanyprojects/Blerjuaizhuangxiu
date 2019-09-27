//
//  distributionenvelopeHeaderView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionenvelopeHeaderView.h"

@interface distributionenvelopeHeaderView()
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UILabel *moneyLab0;
@property (nonatomic,strong) UILabel *moneyLab1;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *bottomLab;
@end

@implementation distributionenvelopeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = White_Color;
        [self addSubview:self.img];
        [self addSubview:self.topLab];
        [self addSubview:self.moneyLab0];
        [self addSubview:self.moneyLab1];
        [self addSubview:self.submitBtn];
        [self addSubview:self.bgView];
        [self addSubview:self.bottomLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(NSString *)cashMoney and:(NSString *)moneyTotal;
{
//    float moneyfl = [cashMoney floatValue];
//    NSString *newstr = [NSString stringWithFormat:@"%.2f",moneyfl];
    
    self.moneyLab0.text = [NSString stringWithFormat:@"%@%@",@"￥",cashMoney];
    NSString *str1 = @"可提现金额";
    NSString *str2 = [NSString stringWithFormat:@"%@%@",moneyTotal,@"元"];
    NSString *newStr = [str1 stringByAppendingString:str2];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor hexStringToColor:@"999999"]
     
                          range:NSMakeRange(0, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor hexStringToColor:@"24B764"]
     
                          range:NSMakeRange(str1.length, str2.length)];
    self.moneyLab1.attributedText = AttributedStr;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(83);
        make.height.mas_offset(99);
        make.top.equalTo(weakSelf).with.offset(15);
    }];
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.img.mas_bottom).with.offset(14);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.moneyLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf.topLab);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(12);
    }];
    [weakSelf.moneyLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf.topLab);
        make.top.equalTo(weakSelf.moneyLab0.mas_bottom).with.offset(15);
    }];
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(268);
        make.height.mas_offset(38);
        make.top.equalTo(weakSelf.moneyLab1.mas_bottom).with.offset(15);
    }];
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(300);
        make.height.mas_offset(32);
    }];
    [weakSelf.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bgView);
        make.bottom.equalTo(weakSelf.bgView);
        make.left.equalTo(weakSelf).with.offset(15);
    }];
}

#pragma mark - getters

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"hongbaoguanliqiandai"];
    }
    return _img;
}

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.font = [UIFont systemFontOfSize:15];
        _topLab.textColor = Black_Color;
        _topLab.text = @"红包总金额";
    }
    return _topLab;
}

-(UILabel *)moneyLab0
{
    if(!_moneyLab0)
    {
        _moneyLab0 = [[UILabel alloc] init];
        //_moneyLab0.text = @"￥19999";
        _moneyLab0.textAlignment = NSTextAlignmentCenter;
        _moneyLab0.textColor = Black_Color;
        _moneyLab0.font = [UIFont systemFontOfSize:30];
    }
    return _moneyLab0;
}

-(UILabel *)moneyLab1
{
    if(!_moneyLab1)
    {
        _moneyLab1 = [[UILabel alloc] init];
        _moneyLab1.textAlignment = NSTextAlignmentCenter;
       // _moneyLab1.text = @"可提现金额：888元";
        _moneyLab1.font = [UIFont systemFontOfSize:14];
        _moneyLab1.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _moneyLab1;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = Main_Color;
        _submitBtn.layer.masksToBounds = YES;
        _submitBtn.layer.cornerRadius = 4;
        [_submitBtn setTitle:@"提现" forState:normal];
    }
    return _submitBtn;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor hexStringToColor:@"F8F6F7"];
        
    }
    return _bgView;
}

-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.font = [UIFont systemFontOfSize:15];
        _bottomLab.textColor = [UIColor hexStringToColor:@"999999"];
        _bottomLab.text = @"领取记录（收到红包后7天可以提现）";
    }
    return _bottomLab;
}

@end
