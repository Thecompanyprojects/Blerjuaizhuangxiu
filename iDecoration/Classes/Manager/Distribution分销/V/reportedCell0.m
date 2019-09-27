//
//  reportedCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "reportedCell0.h"

@interface reportedCell0()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *leftlab;

@end

@implementation reportedCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.codetext];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(20);
        make.width.mas_offset(60);
    }];
    [weakSelf.codetext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftlab.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
        
    }];
}

#pragma  mark - getters


-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.text = @"公司ID";
        _leftlab.font = [UIFont systemFontOfSize:13];
        _leftlab.textColor = [UIColor hexStringToColor:@"676767"];
    }
    return _leftlab;
}


-(UITextField *)codetext
{
    if(!_codetext)
    {
        _codetext = [[UITextField alloc] init];
        _codetext.delegate = self;
        _codetext.placeholder = @"请输入商家公司的ID号码";
        _codetext.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codetext;
}



@end
