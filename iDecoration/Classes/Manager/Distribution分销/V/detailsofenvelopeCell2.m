//
//  detailsofenvelopeCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "detailsofenvelopeCell2.h"

@interface detailsofenvelopeCell2()
@property (nonatomic,strong) UILabel *leftLab0;
@property (nonatomic,strong) UILabel *leftLab1;
@property (nonatomic,strong) UILabel *leftLab2;
@property (nonatomic,strong) UILabel *leftLab3;
@property (nonatomic,strong) UILabel *rightLab0;
@property (nonatomic,strong) UILabel *rightLab1;
@property (nonatomic,strong) UILabel *rightLab2;
@property (nonatomic,strong) UILabel *rightLab3;
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation detailsofenvelopeCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftLab0];
        [self.contentView addSubview:self.leftLab1];
        [self.contentView addSubview:self.leftLab2];
        [self.contentView addSubview:self.leftLab3];
        [self.contentView addSubview:self.rightLab0];
        [self.contentView addSubview:self.rightLab1];
        [self.contentView addSubview:self.rightLab2];
        [self.contentView addSubview:self.rightLab3];
        [self.contentView addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}


-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.top.equalTo(weakSelf).with.offset(22);
        make.width.mas_offset(120);
        
    }];
    [weakSelf.leftLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.top.equalTo(weakSelf.leftLab0.mas_bottom).with.offset(15);
        make.width.mas_offset(120);
    }];
    [weakSelf.leftLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.top.equalTo(weakSelf.leftLab1.mas_bottom).with.offset(15);
        make.width.mas_offset(120);
    }];
    [weakSelf.leftLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.top.equalTo(weakSelf.leftLab2.mas_bottom).with.offset(15);
        make.width.mas_offset(120);
    }];
    [weakSelf.rightLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab0);
        make.width.mas_offset(120);
        make.right.equalTo(weakSelf).with.offset(-120);
    }];
    [weakSelf.rightLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab1);
        make.width.mas_offset(120);
        make.right.equalTo(weakSelf).with.offset(-120);
    }];
    [weakSelf.rightLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab2);
        make.width.mas_offset(120);
        make.right.equalTo(weakSelf).with.offset(-120);
    }];
    [weakSelf.rightLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab3);
        make.width.mas_offset(120);
        make.right.equalTo(weakSelf).with.offset(-120);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftLab3.mas_bottom).with.offset(15);
        make.left.equalTo(weakSelf.leftLab0);
        make.centerX.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UILabel *)leftLab0{
    if(!_leftLab0)
    {
        _leftLab0 = [[UILabel alloc] init];
        _leftLab0.font = [UIFont systemFontOfSize:14];
        _leftLab0.textColor = [UIColor hexStringToColor:@"333333"];
        _leftLab0.text = @"一等奖(1名）";
    }
    return _leftLab0;
}

-(UILabel *)leftLab1
{
    if(!_leftLab1)
    {
        _leftLab1 = [[UILabel alloc] init];
        _leftLab1.font = [UIFont systemFontOfSize:14];
        _leftLab1.textColor = [UIColor hexStringToColor:@"333333"];
        _leftLab1.text = @"二等奖(3名)";
    }
    return _leftLab1;
}

-(UILabel *)leftLab2
{
    if(!_leftLab2)
    {
        _leftLab2 = [[UILabel alloc] init];
        _leftLab2.font = [UIFont systemFontOfSize:14];
        _leftLab2.text = @"三等奖(10名)";
        _leftLab2.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _leftLab2;
}

-(UILabel *)leftLab3
{
    if(!_leftLab3)
    {
        _leftLab3 = [[UILabel alloc] init];
        _leftLab3.font = [UIFont systemFontOfSize:14];
        _leftLab3.text = @"四等奖(500名)";
        _leftLab3.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _leftLab3;
}

-(UILabel *)rightLab0
{
    if(!_rightLab0)
    {
        _rightLab0 = [[UILabel alloc] init];
        _rightLab0.textAlignment = NSTextAlignmentRight;
        
        NSString *str1 = @"红包金额";
        NSString *str2 = @"1888";
        NSString *str3 = @"元";
        NSString *newString = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newString];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"FF0000"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(str1.length+str2.length, str3.length)];
        _rightLab0.attributedText = AttributedStr;
        _rightLab0.font = [UIFont systemFontOfSize:14];
        
    }
    return _rightLab0;
}

-(UILabel *)rightLab1
{
    if(!_rightLab1)
    {
        _rightLab1 = [[UILabel alloc] init];
        _rightLab1.textAlignment = NSTextAlignmentRight;
        NSString *str1 = @"红包金额";
        NSString *str2 = @"888";
        NSString *str3 = @"元";
        NSString *newString = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newString];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"FF0000"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(str1.length+str2.length, str3.length)];
        _rightLab1.attributedText = AttributedStr;
        _rightLab1.font = [UIFont systemFontOfSize:14];
    }
    return _rightLab1;
}

-(UILabel *)rightLab2
{
    if(!_rightLab2)
    {
        _rightLab2 = [[UILabel alloc] init];
        _rightLab2.textAlignment = NSTextAlignmentRight;
        NSString *str1 = @"红包金额";
        NSString *str2 = @"88";
        NSString *str3 = @"元";
        NSString *newString = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newString];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"FF0000"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(str1.length+str2.length, str3.length)];
        _rightLab2.attributedText = AttributedStr;
        _rightLab2.font = [UIFont systemFontOfSize:14];
    }
    return _rightLab2;
}

-(UILabel *)rightLab3
{
    if(!_rightLab3)
    {
        _rightLab3 = [[UILabel alloc] init];
        _rightLab3.textAlignment = NSTextAlignmentRight;
        NSString *str1 = @"红包金额";
        NSString *str2 = @"8.88";
        NSString *str3 = @"元";
        NSString *newString = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newString];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(0, str1.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"FF0000"]
         
                              range:NSMakeRange(str1.length, str2.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor hexStringToColor:@"333333"]
         
                              range:NSMakeRange(str1.length+str2.length, str3.length)];
        _rightLab3.attributedText = AttributedStr;
        _rightLab3.font = [UIFont systemFontOfSize:14];
    }
    return _rightLab3;
}


-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"*每月红包奖金池会有所变动，如有更改恕不另行通知。";
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _contentLab;
}


@end
