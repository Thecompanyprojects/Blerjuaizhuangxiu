//
//  bindingphoneCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "bindingphoneCell1.h"

@interface bindingphoneCell1()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UIView *line;
@end

@implementation bindingphoneCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.setBtn];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.codeText];
        [self setuplauout];
        [WLButtonCountdownManager defaultManager];
    }
    return self;
}


-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(15);
        make.width.mas_offset(60);
    }];
    [weakSelf.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf.leftLab);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(80);
        
    }];
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(10);
        make.width.mas_offset(1);
        make.right.equalTo(weakSelf.setBtn.mas_left).with.offset(-14);
    }];
    [weakSelf.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.top.equalTo(weakSelf.leftLab);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(10);
        make.right.equalTo(weakSelf.line.mas_left).with.offset(10);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = [UIColor hexStringToColor:@"000000"];
        _leftLab.text = @"验证码";
    }
    return _leftLab;
}


-(WLCaptcheButton *)setBtn
{
    if(!_setBtn)
    {
        _setBtn = [[WLCaptcheButton alloc] init];
        [_setBtn setTitle:@"获取验证码" forState:normal];
        [_setBtn setTitleColor:[UIColor hexStringToColor:@"010101"] forState:normal];
        _setBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_setBtn addTarget:self action:@selector(setbtnclick) forControlEvents:UIControlEventTouchUpInside];
        _setBtn.identifyKey = @"120";
    }
    return _setBtn;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"BFBFBF"];
    }
    return _line;
}

-(UITextField *)codeText
{
    if(!_codeText)
    {
        _codeText = [[UITextField alloc] init];
        _codeText.delegate = self;
        _codeText.placeholder = @"请输入您的验证码";
    }
    return _codeText;
}

#pragma mark - 实现方法

-(void)setbtnclick {
    if (self.blockDidTouchButton) {
        self.blockDidTouchButton();
    }
}



@end
