//
//  collectionsiteCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "collectionsiteCell.h"
#import "CollectionModel.h"

@interface collectionsiteCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *companyLab;
@property (nonatomic,strong) UILabel *addressLab;
@property (nonatomic,strong) UILabel *timeLab;
@end

@implementation collectionsiteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.companyLab];
        [self.contentView addSubview:self.addressLab];
        [self.contentView addSubview:self.timeLab];
        [self layout];
    }
    return self;
}

-(void)setdata:(CollectionModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.nameLab.text = model.trueName;
    //self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.ccCreateDate];
    self.timeLab.text = model.ccSrartTime;
    self.companyLab.text = [NSString stringWithFormat:@"%@%@",@"施工单位：",model.ccBuilder];
    self.addressLab.text = [NSString stringWithFormat:@"%@%@",@"小区:",model.ccAreaName];
}

-(void)layout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(92);
        make.height.mas_offset(92);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.leftImg).with.offset(5);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.nameLab);
    }];
    [weakSelf.companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf.timeLab);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(24);
    }];
    [weakSelf.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.companyLab);
        make.right.equalTo(weakSelf.companyLab);
        make.top.equalTo(weakSelf.companyLab.mas_bottom).with.offset(8);
    }];
}

#pragma mark - getters


-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
        _leftImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = Black_Color;
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}


-(UILabel *)companyLab
{
    if(!_companyLab)
    {
        _companyLab = [[UILabel alloc] init];
        _companyLab.font = [UIFont systemFontOfSize:14];
        _companyLab.textColor = [UIColor hexStringToColor:@"666666"];
    }
    return _companyLab;
}

-(UILabel *)addressLab
{
    if(!_addressLab)
    {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = [UIFont systemFontOfSize:14];
        _addressLab.textColor = [UIColor hexStringToColor:@"666666"];
    }
    return _addressLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _timeLab;
}



@end
