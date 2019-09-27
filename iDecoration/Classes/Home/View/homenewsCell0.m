//
//  homenewsCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "homenewsCell0.h"
#import "homenewsModel.h"
#import "Timestr.h"

@interface homenewsCell0()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *addressLab;
@end

@implementation homenewsCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.addressLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(homenewsModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.nameLab.text = model.companyName;
    self.addressLab.text = [Timestr newdatetime:model.addTime];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(40);
        make.height.mas_offset(40);
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(14);
        make.top.equalTo(weakSelf.iconImg);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    [weakSelf.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(14);
        make.bottom.equalTo(weakSelf.iconImg);
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
        _nameLab.textColor = [UIColor hexStringToColor:@"233040"];
    }
    return _nameLab;
}

-(UILabel *)addressLab
{
    if(!_addressLab)
    {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:12];
        _addressLab.textColor = [UIColor hexStringToColor:@"868686"];
    }
    return _addressLab;
}

@end
