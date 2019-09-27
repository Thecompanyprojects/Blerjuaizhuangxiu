//
//  newstousuCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newstousuCell1.h"

@interface newstousuCell1()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *leftLab;
@end

@implementation newstousuCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(90);
    }];
    
    [weakSelf.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(1);
    }];
    
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = [UIColor hexStringToColor:@"3F3F3F"];
        _leftLab.text = @"联系方式：";
        _leftLab.font = [UIFont systemFontOfSize:14];
    }
    return _leftLab;
}


-(UITextField *)phoneText
{
    if(!_phoneText)
    {
        _phoneText = [[UITextField alloc] init];
        _phoneText.delegate = self;
        _phoneText.keyboardType = UIKeyboardTypePhonePad;
        _phoneText.delegate = @"请输入手机号";
    }
    return _phoneText;
}



@end
