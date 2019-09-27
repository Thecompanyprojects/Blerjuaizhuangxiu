//
//  incomedetailsCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "incomedetailsCell.h"
#import "incomelistModel.h"
#import "CashList.h"

@interface incomedetailsCell()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *companyLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UIButton *rightBtn;
@end


@implementation incomedetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.rightBtn];
       // [self setuplauout];
    }
    return self;
}

-(void)settixian:(CashList *)model
{
    [self setuplauout2];
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.withdrawalsTime];
    if ([model.withdrawalsMode isEqualToString:@"0"]) {
        self.nameLab.text = @"提现到支付宝";
    }
    if ([model.withdrawalsMode isEqualToString:@"1"]) {
        self.nameLab.text = @"提现到微信";
    }
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"-¥",model.withdrawalsMoney];
    self.companyLab.text = [NSString stringWithFormat:@"%@%@",@"订单号:",model.orderId];
    _moneyLab.font = [UIFont systemFontOfSize:15];
    _moneyLab.textColor = [UIColor hexStringToColor:@"FF3131"];
}

-(void)setdata:(incomelistModel *)model andwithcelltype:(NSString *)type andwithvctype:(NSString *)vctype
{
    [self setuplauout];
    self.nameLab.text = @"收到";
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",model.incomeMoney,@"元"];
    self.companyLab.text = model.companyName;
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.incomeTime];
    _moneyLab.font = [UIFont systemFontOfSize:17];
    _moneyLab.textColor = [UIColor hexStringToColor:@"F5E42B"];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    weakSelf.timeLab.textAlignment = NSTextAlignmentLeft;
    
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(12);
       
    }];
    
    [weakSelf.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(4);
        
    }];
    
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.width.mas_offset(kSCREEN_WIDTH/2);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(4);
    }];
    
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab.mas_right).with.offset(8);
        make.bottom.equalTo(weakSelf.nameLab);
    }];
    
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf).with.offset(-48);
    }];
    
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.typeLab);
        make.top.equalTo(weakSelf.timeLab);
    }];
}

-(void)setuplauout2
{
    __weak typeof (self) weakSelf = self;
    weakSelf.timeLab.textAlignment = NSTextAlignmentRight;
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(17);
        make.width.mas_offset(kSCREEN_WIDTH/2);
    }];
    
    [weakSelf.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(8);
        
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.nameLab);
    }];
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.timeLab);
        make.top.equalTo(weakSelf.companyLab);
    }];
}

#pragma mark - getters


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        //_nameLab.text = @"推广基本补助";
        _nameLab.font = [UIFont systemFontOfSize:12];
        _nameLab.textColor = [UIColor hexStringToColor:@"000000"];
    }
    return _nameLab;
}

-(UILabel *)companyLab
{
    if(!_companyLab)
    {
        _companyLab = [[UILabel alloc] init];
        _companyLab.font = [UIFont systemFontOfSize:12];
        _companyLab.text = @"公司ID:123456";
        _companyLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _companyLab;
}



-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"2018:04:09 08:37:32";
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _timeLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
      
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.text = @"¥500";
    }
    return _moneyLab;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.text = @"已到账";
        _typeLab.font = [UIFont systemFontOfSize:12];
        _typeLab.textColor = [UIColor hexStringToColor:@"25B764"];
    }
    return _typeLab;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_rightBtn setTitle:@"查看报单卡>>" forState:normal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightBtn setTitleColor:[UIColor hexStringToColor:@"25B764"] forState:normal];
        [_rightBtn addTarget:self action:@selector(rightBtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


-(void)rightBtnclick
{
    [self.delegate myTabVClick:self];
}

@end
