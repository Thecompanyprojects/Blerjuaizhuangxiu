//
//  DistributionwithdrawalCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "DistributionwithdrawalCell0.h"

@interface DistributionwithdrawalCell0()
@property (nonatomic,strong) UILabel *contentLab;
@end

@implementation DistributionwithdrawalCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.contentLab];
        [self setuplauout];

    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}

-(void)setdata:(NSString *)name;
{
    NSString *str1 = @"提现用户：";
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,name];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"000000"]
                          range:NSMakeRange(0, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"898888"]
                          range:NSMakeRange(str1.length, name.length)];
    self.contentLab.attributedText = AttributedStr;
}

@end
