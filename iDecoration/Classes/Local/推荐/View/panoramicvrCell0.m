//
//  panoramicvrCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "panoramicvrCell0.h"
#import "panoramicvrModel.h"

@interface panoramicvrCell0()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@end

@implementation panoramicvrCell0


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(panoramicvrModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.nameLab.text = model.companyName;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(40);
        make.height.mas_offset(40);
        make.left.equalTo(weakSelf).with.offset(8);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImg);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(12);
        make.centerX.equalTo(weakSelf);
        
    }];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 20;
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = [UIColor hexStringToColor:@"233440"];
    }
    return _nameLab;
}



@end
