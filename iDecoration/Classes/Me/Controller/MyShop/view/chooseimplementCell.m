//
//  chooseimplementCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "chooseimplementCell.h"
#import "CompanyPeopleInfoModel.h"

@interface chooseimplementCell()
@property (nonatomic,strong) UIImageView *iconimg;
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) UILabel *typelab;
@property (nonatomic,strong) UIButton *chooseBtn;
@property (nonatomic,strong) CompanyPeopleInfoModel *cmodel;
@end

@implementation chooseimplementCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconimg];
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.contentlab];
        [self.contentView addSubview:self.typelab];
        [self.contentView addSubview:self.chooseBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.top.equalTo(weakSelf).with.offset(20);
        make.width.mas_offset(40);
        make.height.mas_offset(40);
    }];
    [weakSelf.namelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconimg.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.iconimg).with.offset(10);
        
    }];
    [weakSelf.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconimg);
        make.top.equalTo(weakSelf.iconimg.mas_bottom).with.offset(20);
    }];
    [weakSelf.typelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf).with.offset(20);
    }];
    [weakSelf.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-10);
        make.bottom.equalTo(weakSelf).with.offset(-15);
        make.width.mas_offset(18);
        make.height.mas_offset(18);
    }];
}

#pragma mark - getters


-(UIImageView *)iconimg
{
    if(!_iconimg)
    {
        _iconimg = [[UIImageView alloc] init];
        
    }
    return _iconimg;
}

-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        
    }
    return _namelab;
}


-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.text = @"是否设置为执行经理";
        _contentlab.font = [UIFont systemFontOfSize:15];
        _contentlab.textColor = [UIColor hexStringToColor:@"909090"];
    }
    return _contentlab;
}

-(UILabel *)typelab
{
    if(!_typelab)
    {
        _typelab = [[UILabel alloc] init];
        _typelab.textAlignment = NSTextAlignmentRight;
        _typelab.font = [UIFont systemFontOfSize:15];
        _typelab.textColor = [UIColor hexStringToColor:@"909090"];
    }
    return _typelab;
}


-(UIButton *)chooseBtn
{
    if(!_chooseBtn)
    {
        _chooseBtn = [[UIButton alloc] init];
      
        [_chooseBtn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

-(void)setdata:(CompanyPeopleInfoModel *)model
{
    self.cmodel = model;
    [self.iconimg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.namelab.text = model.agencysName;
    self.typelab.text = model.jobName;
  
}

-(void)setchoose:(NSString *)choosestr
{
    if ([choosestr isEqualToString:@"1"]) {
        [self.chooseBtn setImage:[UIImage imageNamed:@"pitch"] forState:normal];
    }
    else
    {
        [self.chooseBtn setImage:[UIImage imageNamed:@"pitch0"] forState:normal];
    }
}

#pragma mark - 实现方法

-(void)btnclick
{
    self.cmodel.ischoose=!self.cmodel.ischoose;
    [self.delegate myTabVClick:self];
}

@end
