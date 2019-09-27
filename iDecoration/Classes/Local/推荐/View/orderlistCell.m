//
//  orderlistCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "orderlistCell.h"
#import "rankingModel.h"

@interface orderlistCell()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *numberLab;
@end

@implementation orderlistCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftView];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.numberLab];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(rankingModel *)model
{
    if (model.companyName.length>8) {
        NSString *subString1 = [model.companyName substringToIndex:7];
        NSString *subString2 = @"...";
        NSString *str = [subString1 stringByAppendingString:subString2];
        self.nameLab.text = str;
    }
    else
    {
        self.nameLab.text = model.companyName;
    }
    NSString *str1 = @"已咨询：";
    NSString *str2 = [NSString stringWithFormat:@"%@%@",model.counts,@"人"];
    NSString *str = [NSString stringWithFormat:@"%@%@",str1,str2];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"666666"]
                          range:NSMakeRange(0, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"FE8104"]
                          range:NSMakeRange(str1.length, str2.length)];
    self.numberLab.attributedText = AttributedStr;
}

-(void)setnumber:(NSString *)num
{
    self.leftView.numberlab.text = num;
    if ([num isEqualToString:@"2"]||[num isEqualToString:@"3"]) {
        self.leftView.bgimg.image = [UIImage imageNamed:@"jingqi_yello"];
    }
    else
    {
        self.leftView.bgimg.image = [UIImage imageNamed:@"jingqi_gray"];
    }
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(17);
        make.height.mas_offset(18);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.leftView.mas_right).with.offset(10);
        make.height.mas_offset(20);

    }];
    [weakSelf.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(18);

    }];
}

#pragma mark - getters

-(orderleftImg *)leftView
{
    if(!_leftView)
    {
        _leftView = [[orderleftImg alloc] init];
        
    }
    return _leftView;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}

-(UILabel *)numberLab
{
    if(!_numberLab)
    {
        _numberLab = [[UILabel alloc] init];
        _numberLab.textAlignment = NSTextAlignmentRight;
        _numberLab.font = [UIFont systemFontOfSize:14];
    }
    return _numberLab;
}

@end
