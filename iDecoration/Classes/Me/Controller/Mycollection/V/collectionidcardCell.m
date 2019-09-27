//
//  collectionidcardCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "collectionidcardCell.h"
#import "CollectionModel.h"
#import "UILabel+LabelHeightAndWidth.h"


@interface collectionidcardCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *companyLab;
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UILabel *lab1;
@end

@implementation collectionidcardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:self.lab0];
        [self.contentView addSubview:self.lab1];
        [self layout];
    }
    return self;
}

-(void)setdata:(CollectionModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.nameLab.text = model.trueName;
    self.companyLab.text = model.companyName;
    
    self.lab0.text = model.cJobTypeName2;
    self.lab1.text = model.cJobTypeName1;
    
    CGFloat width0 = [UILabel getWidthWithTitle:self.lab0.text font:[UIFont systemFontOfSize:12]];
    CGFloat width1 = [UILabel getWidthWithTitle:self.lab1.text font:[UIFont systemFontOfSize:12]];
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(12);
        make.width.mas_offset(width0+2);
    }];
    
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab0.mas_right).with.offset(8);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(12);
        make.width.mas_offset(width1+2);
    }];
}

-(void)layout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(69);
        make.height.mas_offset(69);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(98);
        make.top.equalTo(weakSelf.leftImg);
        
    }];
    [weakSelf.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(8);
        make.height.mas_offset(18);
    }];

    [weakSelf.lab0  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(12);
        make.width.mas_offset(50);
    }];
    [weakSelf.lab0  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab0.mas_right).with.offset(8);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(12);
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


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
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
        _companyLab.textColor = [UIColor hexStringToColor:@"666666"];
        _companyLab.font = [UIFont systemFontOfSize:14];
    }
    return _companyLab;
}

-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.backgroundColor = [UIColor hexStringToColor:@"FEF6ED"];
        _lab0.textColor = [UIColor hexStringToColor:@"F29C2E"];
        _lab0.font = [UIFont systemFontOfSize:12];
        _lab0.textAlignment = NSTextAlignmentCenter;
    }
    return _lab0;
}

-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textColor = [UIColor hexStringToColor:@"2AACFF"];
        _lab1.font = [UIFont systemFontOfSize:12];
        _lab1.backgroundColor = [UIColor hexStringToColor:@"EEF8FE"];
        _lab1.textAlignment = NSTextAlignmentCenter;
    }
    return _lab1;
}





@end
