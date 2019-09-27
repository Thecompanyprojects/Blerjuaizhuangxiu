//
//  distributionrecorecordCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionrecorecordCell.h"

@interface distributionrecorecordCell()
@property (nonatomic,strong) UILabel *leftlab;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) UILabel *moneylab;
@end

@implementation distributionrecorecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.moneylab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(20);
    }];
    [weakSelf.timelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftlab);
        make.bottom.equalTo(weakSelf).with.offset(-20);
    }];
    [weakSelf.moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-20);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.font = [UIFont systemFontOfSize:15];
        _leftlab.textColor = [UIColor hexStringToColor:@"000000"];
        _leftlab.text = @"提现到支付宝";
    }
    return _leftlab;
}

-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.font = [UIFont systemFontOfSize:13];
        _timelab.textColor = [UIColor hexStringToColor:@"999999"];
        _timelab.text = @"2018:3:29 15:44";
    }
    return _timelab;
}

-(UILabel *)moneylab
{
    if(!_moneylab)
    {
        _moneylab = [[UILabel alloc] init];
        _moneylab.font = [UIFont systemFontOfSize:15];
        _moneylab.textAlignment = NSTextAlignmentRight;
        _moneylab.textColor = [UIColor hexStringToColor:@"FF3131"];
        _moneylab.text = @"¥300";
    }
    return _moneylab;
}






@end
