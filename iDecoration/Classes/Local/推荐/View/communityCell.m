//
//  communityCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "communityCell.h"
#import "localcommunityModel.h"

@interface communityCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *typeLab;
@end

@implementation communityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.addressLab];
        [self.contentView addSubview:self.typeLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(localcommunityModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.covermap]];
    self.titleLab.text = model.communityName;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",@"地址：",model.address];
    
    NSString *str0 = @"户型 ";
    NSString *str1 = [NSString stringWithFormat:@"%ld",model.mobelCount];
    NSString *str2 = @"案例 ";
    NSString *str3 = [NSString stringWithFormat:@"%ld",model.consCount];
    NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@",str0,str1,str2,str3];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newStr];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"999999"]
                          range:NSMakeRange(0, str0.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"25B764"]
                          range:NSMakeRange(str0.length, str1.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"999999"]
                          range:NSMakeRange(str0.length+str1.length, str2.length)];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor hexStringToColor:@"25B764"]
                          range:NSMakeRange(str0.length+str1.length+str2.length, str3.length)];
    self.typeLab.attributedText = AttributedStr;
    
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(7);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(112);
        make.height.mas_offset(70);
    }];
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(8);
        make.right.equalTo(weakSelf).with.offset(-10);
    }];
    [weakSelf.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.titleLab.mas_bottom).with.offset(15);
    }];
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titleLab);
        make.right.equalTo(weakSelf.titleLab);
        make.top.equalTo(weakSelf.addressLab.mas_bottom).with.offset(8);
    }];
}

#pragma mark - getters

-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        
    }
    return _leftImg;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _titleLab;
}

-(UILabel *)addressLab
{
    if(!_addressLab)
    {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:12];
        _addressLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _addressLab;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
//        _typeLab.textColor = [UIColor hexStringToColor:@"999999"];
        _typeLab.font = [UIFont systemFontOfSize:12];
    }
    return _typeLab;
}

@end
