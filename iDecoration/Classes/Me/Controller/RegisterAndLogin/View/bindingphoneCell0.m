//
//  bindingphoneCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "bindingphoneCell0.h"

@interface bindingphoneCell0()<UITextFieldDelegate>

@end

@implementation bindingphoneCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.phoneText];
        [self setuplauout];
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
    [weakSelf.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.leftLab);
        make.right.equalTo(weakSelf).with.offset(-15);
        make.centerY.equalTo(weakSelf);
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
        _leftLab.text = @"手机号";
    }
    return _leftLab;
}

-(UITextField *)phoneText
{
    if(!_phoneText)
    {
        _phoneText = [[UITextField alloc] init];
        _phoneText.delegate = self;
        _phoneText.placeholder = @"请输入您要绑定的手机号码";
        _phoneText.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneText;
}



@end
