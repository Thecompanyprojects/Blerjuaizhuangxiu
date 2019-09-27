//
//  localofferCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localofferCell.h"
#import "localofferModel.h"

@interface localofferCell()
@property (nonatomic,strong) UIImageView *leftimg;
@property (nonatomic,strong) UIImageView *typeimg;
@property (nonatomic,strong) UILabel *titlelab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIImageView *vip0;
@property (nonatomic,strong) UIImageView *vip1;
@property (nonatomic,strong) UILabel *typeLab;
@end

@implementation localofferCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftimg];
        [self.contentView addSubview:self.typeimg];
        [self.contentView addSubview:self.titlelab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.btn0];
        [self.contentView addSubview:self.vip0];
        [self.contentView addSubview:self.vip1];
        [self.contentView addSubview:self.typeLab];
      
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(localofferModel *)model andwithtype:(NSString *)type
{
    
    if ([type isEqualToString:@"0"]) {
        CGFloat fld = [model.distince floatValue];
        CGFloat newfld = fld/1000;
        NSString *str = [NSString stringWithFormat:@"%.2f",newfld];
        self.typeLab.text = [NSString stringWithFormat:@"%@%@",str,@"km"];
    }
    if ([type isEqualToString:@"1"]) {
        self.typeLab.text = [NSString stringWithFormat:@"%@%@",@"好评数",model.flowers];
    }
    if ([type isEqualToString:@"2"]) {
        self.typeLab.text = [NSString stringWithFormat:@"%@%@",@"信用值",model.banners];
    }
    
    [self.leftimg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.titlelab.text = model.companyName;
    self.contentLab.text = model.companySlogan?:@"";
    if (model.appVip==1) {
        [self.vip0 setHidden:NO];
    }
    else
    {
        [self.vip0 setHidden:YES];
    }
    if (model.svip==1) {
        [self.vip1 setHidden:NO];
    }
    else
    {
        [self.vip1 setHidden:YES];
    }
   
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(90);
        make.height.mas_offset(70);
    }];
    [weakSelf.typeimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftimg);
        make.top.equalTo(weakSelf.leftimg);
        make.width.mas_offset(39);
        make.height.mas_offset(34);
    }];
    [weakSelf.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftimg.mas_right).with.offset(14);
        make.top.equalTo(weakSelf.leftimg);
        make.height.mas_offset(20);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftimg.mas_right).with.offset(14);
        make.top.equalTo(weakSelf.titlelab.mas_bottom).with.offset(10);
        make.height.mas_offset(16);
    }];
    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.titlelab);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(10);
        make.height.mas_offset(16);
        make.width.mas_offset(60);
    }];

    [weakSelf.vip0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titlelab);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
        make.left.equalTo(weakSelf.titlelab.mas_right).with.offset(10);
    }];
    [weakSelf.vip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titlelab);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
        make.left.equalTo(weakSelf.vip0.mas_right).with.offset(6);
    }];
    [weakSelf.typeimg setHidden:YES];
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.btn0);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.width.mas_offset(100);
        make.height.mas_offset(14);
    }];
}

#pragma mark - getters


-(UIImageView *)leftimg
{
    if(!_leftimg)
    {
        _leftimg = [[UIImageView alloc] init];
        
    }
    return _leftimg;
}



-(UIImageView *)typeimg
{
    if(!_typeimg)
    {
        _typeimg = [[UIImageView alloc] init];
        _typeimg.image = [UIImage imageNamed:@"img_zhongbangtuijian"];
    }
    return _typeimg;
}


-(UILabel *)titlelab
{
    if(!_titlelab)
    {
        _titlelab = [[UILabel alloc] init];
        _titlelab.font = [UIFont systemFontOfSize:17];
        _titlelab.textColor = [UIColor darkGrayColor];
        _titlelab.text = @"佳家通装修装饰公司";
    }
    return _titlelab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = [UIColor hexStringToColor:@"727272"];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.text = @"装修要花多少钱，点我出报价";
    }
    return _contentLab;
}


-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setTitle:@"生成预算" forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:10];
        _btn0.layer.masksToBounds = YES;
        _btn0.layer.borderWidth = 1;
        _btn0.layer.cornerRadius = 4;
        _btn0.layer.borderColor = [UIColor hexStringToColor:@"FA7C23"].CGColor;
        [_btn0 setTitleColor:[UIColor hexStringToColor:@"FA7C23"] forState:normal];
    }
    return _btn0;
}


-(UIImageView *)vip0
{
    if(!_vip0)
    {
        _vip0 = [[UIImageView alloc] init];
        _vip0.image = [UIImage imageNamed:@"vip1"];
    }
    return _vip0;
}

-(UIImageView *)vip1
{
    if(!_vip1)
    {
        _vip1 = [[UIImageView alloc] init];
        _vip1.image = [UIImage imageNamed:@"zhuanshi"];
    }
    return _vip1;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.textAlignment = NSTextAlignmentRight;
        _typeLab.font = [UIFont systemFontOfSize:13];
        _typeLab.textColor = [UIColor lightGrayColor];
    }
    return _typeLab;
}

@end
