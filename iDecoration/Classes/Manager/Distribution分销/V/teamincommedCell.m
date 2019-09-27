//
//  teamincommedCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "teamincommedCell.h"

@interface teamincommedCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *isLevelLab;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *companyLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation teamincommedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.isLevelLab];
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.moneyLab];
        
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(21);
        make.width.mas_offset(45);
        make.height.mas_offset(45);
    }];

    [weakSelf.isLevelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(18);
        make.width.mas_offset(60);
        make.height.mas_offset(17);
        make.bottom.equalTo(weakSelf.iconImg.mas_bottom).with.offset(8);
    }];

    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.isLevelLab).with.offset(-5);
        make.bottom.equalTo(weakSelf.isLevelLab);
        make.height.mas_offset(25);
        make.width.mas_offset(22);
        make.right.equalTo(weakSelf.isLevelLab.mas_left).with.offset(5);
    }];
    
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImg.mas_right).with.offset(18);
        make.top.equalTo(weakSelf).with.offset(17);
        make.width.mas_offset(kSCREEN_WIDTH/2);
    }];

    [weakSelf.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(4);

    }];
    
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.width.mas_offset(kSCREEN_WIDTH/2);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(4);
    }];

    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters


-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 45/2;
    }
    return _iconImg;
}



-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"推广基本补助";
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor hexStringToColor:@"000000"];
    }
    return _nameLab;
}

-(UILabel *)companyLab
{
    if(!_companyLab)
    {
        _companyLab = [[UILabel alloc] init];
        _companyLab.font = [UIFont systemFontOfSize:12];
        _companyLab.text = @"公司ID:123456";
        _companyLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _companyLab;
}



-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.text = @"2018:04:09 08:37:32";
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _timeLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.font = [UIFont systemFontOfSize:15];
        _moneyLab.textColor = [UIColor hexStringToColor:@"FF3131"];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.text = @"¥500";
    }
    return _moneyLab;
}

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"钻石222"];
    }
    return _img;
}


-(UILabel *)isLevelLab
{
    if(!_isLevelLab)
    {
        _isLevelLab = [[UILabel alloc] init];
        _isLevelLab.font = [UIFont systemFontOfSize:10];
        _isLevelLab.textColor = [UIColor whiteColor];
        _isLevelLab.backgroundColor = [UIColor hexStringToColor:@"000000"];
        _isLevelLab.layer.masksToBounds = YES;
        _isLevelLab.textAlignment = NSTextAlignmentCenter;
        _isLevelLab.layer.cornerRadius = 17/2;
        _isLevelLab.text = @"分销员";
    }
    return _isLevelLab;
}

@end
