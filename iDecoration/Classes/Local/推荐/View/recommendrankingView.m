//
//  recommendrankingView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "recommendrankingView.h"

@interface recommendrankingView()

@end

@implementation recommendrankingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImg];
        [self addSubview:self.companyNamelab];
        [self addSubview:self.numberlab];
        [self setuplauout];
    }
    return self;
}

-(void)setdatacontent:(NSString *)contentstr andnumber:(NSString *)numberstr
{
    //self.companyNamelab.text = contentstr;
    [self.companyNamelab setTitle:contentstr forState:normal];
    NSString *str1 = @"已咨询：";
    NSString *str2 = [NSString stringWithFormat:@"%@%@",numberstr,@"人"];
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"666666"]
                          range:NSMakeRange(0, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"FE8104"]
                          range:NSMakeRange(str1.length, str2.length)];
    self.numberlab.attributedText = AttributedStr;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(13);
        make.height.mas_offset(14);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.companyNamelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftImg).with.offset(14);
        make.height.mas_offset(18);
        make.width.mas_offset(220);
    }];
    [weakSelf.numberlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(18);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(120);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.userInteractionEnabled = YES;
    }
    return _leftImg;
}

-(UIButton *)companyNamelab
{
    if(!_companyNamelab)
    {
        _companyNamelab = [[UIButton alloc] init];
//        _companyNamelab.font = [UIFont systemFontOfSize:14];
//        _companyNamelab.textColor = [UIColor hexStringToColor:@"333333"];
        _companyNamelab.titleLabel.font = [UIFont systemFontOfSize:14];
        [_companyNamelab setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _companyNamelab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _companyNamelab.userInteractionEnabled = YES;
    }
    return _companyNamelab;
}

-(UILabel *)numberlab
{
    if(!_numberlab)
    {
        _numberlab = [[UILabel alloc] init];
        _numberlab.textAlignment = NSTextAlignmentRight;
        _numberlab.font = [UIFont systemFontOfSize:12];
        _numberlab.userInteractionEnabled = YES;
    }
    return _numberlab;
}





@end
