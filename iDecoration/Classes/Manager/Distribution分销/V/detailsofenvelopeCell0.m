//
//  detailsofenvelopeCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "detailsofenvelopeCell0.h"

@interface detailsofenvelopeCell0()
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) UILabel *bottomLab;

@end

@implementation detailsofenvelopeCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bgImg];
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.moneyLab];
        [self.contentView addSubview:self.bottomLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(NSDictionary *)dic
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"photo"]]];
   
    self.nameLab.text = [dic objectForKey:@"trueName"];
    float moneyfl = [[dic objectForKey:@"money"] floatValue];

    NSString *moneystr = [NSString stringWithFormat:@"%.2f",moneyfl];
    NSString *newstr = [NSString stringWithFormat:@"%@%@",moneystr,@"元"];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:newstr];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:60]
     
                          range:NSMakeRange(0, moneystr.length)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:17.0]
     
                          range:NSMakeRange(moneystr.length, 1)];
    self.moneyLab.attributedText = AttributedStr;
    
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(-1);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(75);
    }];
    
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(62);
        make.height.mas_offset(62);
        make.top.equalTo(weakSelf).with.offset(32);
    }];
    
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.iconImg.mas_bottom).with.offset(8);
    }];
    
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(8);
    }];
    
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(43);
    }];
    
    [weakSelf.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.moneyLab.mas_bottom).with.offset(14);
    }];
    

}

#pragma mark - getters

-(UIImageView *)bgImg
{
    if(!_bgImg)
    {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"bg_dahongsedi"];
        _bgImg.alpha = 0.9;
    }
    return _bgImg;
}

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 31;
   
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
        _nameLab.font = [UIFont systemFontOfSize:17];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        
    }
    return _nameLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.text = @"恭喜发财，大吉大利";
    }
    return _contentLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
        _moneyLab.font = [UIFont systemFontOfSize:60];
        _moneyLab.textColor = [UIColor hexStringToColor:@"333333"];
        
    }
    return _moneyLab;
}

-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.textAlignment = NSTextAlignmentCenter;
        _bottomLab.text = @"已存入红包管理";
        _bottomLab.font = [UIFont systemFontOfSize:14];
        _bottomLab.textColor = [UIColor hexStringToColor:@"24B764"];
    }
    return _bottomLab;
}


@end
