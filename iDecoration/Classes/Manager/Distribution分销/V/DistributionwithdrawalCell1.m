//
//  DistributionwithdrawalCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionwithdrawalCell1.h"


@interface DistributionwithdrawalCell1()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,strong) UIButton *allBtn;
@property (nonatomic,copy) NSString *money;
@end

@implementation DistributionwithdrawalCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.topLab];
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.moneyText];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.bottomLab];
        [self.contentView addSubview:self.allBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(10);
    }];
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(20);
        make.width.mas_offset(10);
        make.height.mas_offset(14);
    }];
    [weakSelf.moneyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(14);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(25);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(15);
    }];
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(9);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(1);
        make.top.equalTo(weakSelf.moneyText.mas_bottom).with.offset(4);
    }];
    [weakSelf.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.line.mas_bottom).with.offset(5);
        make.width.mas_offset(120);
    }];
    [weakSelf.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bottomLab.mas_right);
        make.top.equalTo(weakSelf.bottomLab);
        make.width.mas_offset(60);
        make.bottom.equalTo(weakSelf.bottomLab);
    }];
}

#pragma mark - getters

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textColor = [UIColor hexStringToColor:@"000000"];
        _topLab.text = @"提现金额";
        _topLab.font = [UIFont systemFontOfSize:13];
    }
    return _topLab;
}


-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"renmingbi"];
    }
    return _leftImg;
}

-(NaText *)moneyText
{
    if(!_moneyText)
    {
        _moneyText = [[NaText alloc] init];
        _moneyText.delegate = self;
        
    }
    return _moneyText;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"999999"];
    }
    return _line;
}


-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.text = @"可用余额0.00元";
        _bottomLab.font = [UIFont systemFontOfSize:12];
        _bottomLab.textColor = [UIColor hexStringToColor:@"919090"];
    }
    return _bottomLab;
}

-(UIButton *)allBtn
{
    if(!_allBtn)
    {
        _allBtn = [[UIButton alloc] init];
        [_allBtn setTitle:@"全部提现" forState:normal];
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_allBtn setTitleColor:[UIColor hexStringToColor:@"24B764"] forState:normal];
        [_allBtn addTarget:self action:@selector(submitclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allBtn;
}

-(void)setdata:(NSString *)accountTotal
{
    if (accountTotal.length==0) {
        self.bottomLab.text = [NSString stringWithFormat:@"%@%@%@",@"可用余额",@"0.00",@"元"];
        self.money = @"";
    }
    else
    {
        self.bottomLab.text = [NSString stringWithFormat:@"%@%@%@",@"可用余额",accountTotal,@"元"];
        self.money = accountTotal;
    }
}

-(void)submitclick
{
    self.moneyText.text = self.money;
}

@end
