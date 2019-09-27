//
//  ApplydistributionCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ApplydistributionCell2.h"

@interface ApplydistributionCell2()<UITextFieldDelegate>

@end

@implementation ApplydistributionCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.codeText];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(35);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(160*WIDTH_SCALE);
        make.height.mas_offset(20);
    }];
    [weakSelf.codeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(20);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(12);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.text = @"对接人邀请码（选填）";
        _leftLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _leftLab;
}

-(UITextField *)codeText
{
    if(!_codeText)
    {
        _codeText = [[UITextField alloc] init];
        _codeText.delegate = self;
        _codeText.textAlignment = NSTextAlignmentRight;
    }
    return _codeText;
}

@end
