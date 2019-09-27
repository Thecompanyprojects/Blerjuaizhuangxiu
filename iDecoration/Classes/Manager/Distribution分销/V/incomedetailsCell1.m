//
//  incomedetailsCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "incomedetailsCell1.h"
#import "incomelistModel.h"
#import "CashList.h"

@interface incomedetailsCell1()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *companyLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation incomedetailsCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
       
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
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
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-12);
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

-(void)setdata:(incomelistModel *)model andwithcelltype:(NSString *)type
{
    [self setuplayout];
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.incomeTime];
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model.incomeMoney];
    
    if ([type isEqualToString:@"1"]) {
        self.nameLab.text = @"被动收入补助";
        self.companyLab.text = [NSString stringWithFormat:@"%@%@",@"分销员",model.downName];
    }
    if ([type isEqualToString:@"3"]) {
        self.nameLab.text = model.downName;
        self.companyLab.text = [NSString stringWithFormat:@"%@%@",@"公司id：",model.companyId];
    }
}

#pragma mark - getters

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
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
        _moneyLab.font = [UIFont systemFontOfSize:15];
        _moneyLab.textColor = [UIColor hexStringToColor:@"FF3131"];
    }
    return _moneyLab;
}


@end
