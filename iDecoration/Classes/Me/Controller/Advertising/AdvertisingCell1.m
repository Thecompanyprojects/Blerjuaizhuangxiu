//
//  AdvertisingCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AdvertisingCell1.h"

@interface AdvertisingCell1()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *leftLab;

@end

@implementation AdvertisingCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.urlText];
        [self setuplauout];
    }
    return self;
}


-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(80);
        
    }];
    [weakSelf.urlText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.centerY.equalTo(weakSelf);
    }];
    
}

#pragma mark - getters


-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.text = @"输入链接";
    }
    return _leftLab;
}


-(UITextField *)urlText
{
    if(!_urlText)
    {
        _urlText = [[UITextField alloc] init];
        _urlText.delegate = self;
        _urlText.placeholder = @"请粘贴或输入链接";
    }
    return _urlText;
}

#pragma mark - UITextField Delegate

@end
