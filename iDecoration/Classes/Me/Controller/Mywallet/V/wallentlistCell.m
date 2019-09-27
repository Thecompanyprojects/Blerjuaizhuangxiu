//
//  wallentlistCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "wallentlistCell.h"
#import "mywalletModel.h"

@interface wallentlistCell()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation wallentlistCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(mywalletModel *)model
{
    if ([model.type isEqualToString:@"1"]) {
        self.nameLab.text = @"打赏费用";
        self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"+",model.money];
        self.moneyLab.textColor = [UIColor hexStringToColor:@"24B764"];
    }
    if ([model.type isEqualToString:@"2"]) {
        self.nameLab.text = @"提现";
        self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"-",model.money];
        self.moneyLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStampWithSeconds:model.time];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.right.equalTo(weakSelf).with.offset(-20);
        make.top.equalTo(weakSelf).with.offset(10);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(11);
        make.left.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf.nameLab);
    }];
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-13);
        make.width.mas_offset(100);
    }];
}

#pragma mark - getters


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = Black_Color;
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
        _timeLab.font = [UIFont systemFontOfSize:13];
    }
    return _timeLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont systemFontOfSize:14];
        _moneyLab.textAlignment = NSTextAlignmentRight;
       
    }
    return _moneyLab;
}




@end
