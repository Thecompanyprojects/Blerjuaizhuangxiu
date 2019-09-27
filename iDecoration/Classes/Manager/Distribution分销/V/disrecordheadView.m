//
//  disrecordheadView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "disrecordheadView.h"

@interface disrecordheadView()
@property (nonatomic,strong) UIImageView *bgimg;
@property (nonatomic,strong) UILabel *toplab;
@property (nonatomic,strong) UILabel *leftlab0;
@property (nonatomic,strong) UILabel *leftlab1;
@property (nonatomic,strong) UILabel *moneylab;

@end

@implementation disrecordheadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgimg];
        [self addSubview:self.toplab];
        [self addSubview:self.moneylab];
        [self addSubview:self.leftlab0];
        [self addSubview:self.leftlab1];
        [self addSubview:self.submitbtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    [weakSelf.toplab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.right.equalTo(weakSelf).with.offset(-20);
        make.top.equalTo(weakSelf).with.offset(14);;
    }];
    [weakSelf.moneylab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(40);
        make.right.equalTo(weakSelf).with.offset(-40);
        make.top.equalTo(weakSelf.toplab.mas_bottom).with.offset(10);
    }];
    [weakSelf.leftlab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(15);
        make.top.equalTo(weakSelf.moneylab.mas_bottom).with.offset(14);
        
    }];
    [weakSelf.leftlab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftlab0);
        make.top.equalTo(weakSelf.leftlab0.mas_bottom).with.offset(10);
    }];
    [weakSelf.submitbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-24);
        make.bottom.equalTo(weakSelf).with.offset(-20);
        make.width.mas_offset(75*WIDTH_SCALE);
        make.height.mas_offset(23*HEIGHT_SCALE);
    }];
}

#pragma mark - getters


-(UIImageView *)bgimg
{
    if(!_bgimg)
    {
        _bgimg = [[UIImageView alloc] init];
        _bgimg.image = [UIImage imageNamed:@"bg_jiaru"];
    }
    return _bgimg;
}


-(UILabel *)toplab
{
    if(!_toplab)
    {
        _toplab = [[UILabel alloc] init];
        _toplab.textAlignment = NSTextAlignmentCenter;
        _toplab.text = @"可提现佣金";
        _toplab.textColor = [UIColor hexStringToColor:@"FFFFFF"];
        _toplab.font = [UIFont systemFontOfSize:13];
    }
    return _toplab;
}


-(UILabel *)moneylab
{
    if(!_moneylab)
    {
        _moneylab = [[UILabel alloc] init];
        _moneylab.textColor = [UIColor hexStringToColor:@"FEFEFE"];
        _moneylab.text = @"¥0.0";
        _moneylab.textAlignment = NSTextAlignmentCenter;
        _moneylab.font = [UIFont systemFontOfSize:33];
    }
    return _moneylab;
}

-(UILabel *)leftlab0
{
    if(!_leftlab0)
    {
        _leftlab0 = [[UILabel alloc] init];
        _leftlab0.textColor = [UIColor whiteColor];
        _leftlab0.font = [UIFont systemFontOfSize:13];
        _leftlab0.text = @"累计奖金:￥0";
    }
    return _leftlab0;
}


-(UILabel *)leftlab1
{
    if(!_leftlab1)
    {
        _leftlab1 = [[UILabel alloc] init];
        _leftlab1.textColor = [UIColor whiteColor];
        _leftlab1.font = [UIFont systemFontOfSize:13];
        _leftlab1.text = @"未结算的佣金:￥0";
    }
    return _leftlab1;
}

-(UIButton *)submitbtn
{
    if(!_submitbtn)
    {
        _submitbtn = [[UIButton alloc] init];
        _submitbtn.layer.masksToBounds = YES;
        _submitbtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _submitbtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_submitbtn setTitle:@"申请提现" forState:normal];
        [_submitbtn setTitleColor:[UIColor whiteColor] forState:normal];
        _submitbtn.backgroundColor = [UIColor clearColor];
        _submitbtn.layer.borderWidth = 2;
        _submitbtn.layer.cornerRadius = 2;
    }
    return _submitbtn;
}

@end
