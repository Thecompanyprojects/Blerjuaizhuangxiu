//
//  showresulefootView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "showresulefootView.h"

@interface showresulefootView()
@property (nonatomic,strong) UILabel *leftLab0;
@property (nonatomic,strong) UILabel *leftLab1;
@property (nonatomic,strong) UILabel *rightLab0;
@property (nonatomic,strong) UILabel *rightLab1;

@end

@implementation showresulefootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.leftLab0];
        [self addSubview:self.rightLab0];
        [self addSubview:self.leftLab1];
        [self addSubview:self.rightLab1];
        [self addSubview:self.submitBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(120);
        make.height.mas_offset(18);
    }];
    [weakSelf.leftLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.leftLab0.mas_bottom).with.offset(10);
        make.width.mas_offset(120);
        make.height.mas_offset(18);
    }];
    [weakSelf.rightLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.leftLab0);
        make.width.mas_offset(80);
    }];
    [weakSelf.rightLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.leftLab1);
        make.width.mas_offset(80);
    }];
    [weakSelf.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab1.mas_bottom).with.offset(60);
        make.left.equalTo(weakSelf).with.offset(20);
        make.height.mas_offset(44);
        make.centerX.equalTo(weakSelf);
    }];
}

#pragma mark - getters



-(UILabel *)leftLab0
{
    if(!_leftLab0)
    {
        _leftLab0 = [[UILabel alloc] init];
        _leftLab0.text = @"提现金额";
        _leftLab0.font = [UIFont systemFontOfSize:14];
        _leftLab0.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _leftLab0;
}


-(UILabel *)leftLab1
{
    if(!_leftLab1)
    {
        _leftLab1 = [[UILabel alloc] init];
        _leftLab1.text = @"到账方式";
        _leftLab1.font = [UIFont systemFontOfSize:14];
        _leftLab1.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _leftLab1;
}

-(UILabel *)rightLab0
{
    if(!_rightLab0)
    {
        _rightLab0 = [[UILabel alloc] init];
        _rightLab0.textAlignment = NSTextAlignmentRight;
        _rightLab0.font = [UIFont systemFontOfSize:14];
        _rightLab0.text = @"¥200";
    }
    return _rightLab0;
}

-(UILabel *)rightLab1
{
    if(!_rightLab1)
    {
        _rightLab1 = [[UILabel alloc] init];
        _rightLab1.textAlignment = NSTextAlignmentRight;
        _rightLab1.font = [UIFont systemFontOfSize:14];
        _rightLab1.text = @"微信";
    }
    return _rightLab1;
}

-(UIButton *)submitBtn
{
    if(!_submitBtn)
    {
        _submitBtn = [[UIButton alloc] init];
        [_submitBtn setTitle:@"完 成" forState:normal];
        [_submitBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        _submitBtn.backgroundColor = Main_Color;
    }
    return _submitBtn;
}





@end
