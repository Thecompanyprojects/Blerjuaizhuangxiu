//
//  optimalproductCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "optimalproductCell.h"
#import "optimalgoodsModel.h"

@interface optimalproductCell()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *infoImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *moneyLab;
@property (nonatomic,strong) UILabel *typeLab0;

@end

@implementation optimalproductCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.infoImg];
        [self addSubview:self.nameLab];
        [self addSubview:self.moneyLab];
        [self addSubview:self.typeLab0];

        [self setuplauout];
    }
    return self;
}

-(void)setdata:(optimalgoodsModel *)model
{
    [self.infoImg sd_setImageWithURL:[NSURL URLWithString:model.faceImg]];
    self.nameLab.text = model.name;
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"¥ ",model.price];
    [self.typeLab0 setHidden:YES];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(5);
        make.top.equalTo(weakSelf).with.offset(5);
        make.centerY.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.infoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgView);
        make.left.equalTo(weakSelf.bgView);
        make.right.equalTo(weakSelf.bgView);
        make.height.mas_offset(186);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.infoImg).with.offset(18);
        make.right.equalTo(weakSelf.infoImg).with.offset(-18);
        make.top.equalTo(weakSelf.infoImg.mas_bottom).with.offset(10);
    }];
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLab);
        make.right.equalTo(weakSelf.nameLab);
        make.height.mas_offset(13);
        make.top.equalTo(weakSelf.nameLab.mas_bottom).with.offset(14);
    }];
    [weakSelf.typeLab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.moneyLab);;
        make.top.equalTo(weakSelf.moneyLab.mas_bottom).with.offset(10);
        make.height.mas_offset(14);
        make.width.mas_offset(60);
    }];

  
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor hexStringToColor:@"FFFFFF"];
    }
    return _bgView;
}

-(UIImageView *)infoImg
{
    if(!_infoImg)
    {
        _infoImg = [[UIImageView alloc] init];
        _infoImg.layer.masksToBounds = YES;
        _infoImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _infoImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.textColor = [UIColor hexStringToColor:@"282B35"];
        _nameLab.text = @"老人椅加茶几三件套/咖啡色木制品，质量保证";
        _nameLab.numberOfLines = 2;
    }
    return _nameLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textColor = [UIColor hexStringToColor:@"F53F34"];
        _moneyLab.text = @"¥ 500";
        _moneyLab.font = [UIFont systemFontOfSize:14];
    }
    return _moneyLab;
}

-(UILabel *)typeLab0
{
    if(!_typeLab0)
    {
        _typeLab0 = [[UILabel alloc] init];
        _typeLab0.font = [UIFont systemFontOfSize:10];
        _typeLab0.textColor = [UIColor hexStringToColor:@"F53F34"];
        _typeLab0.text = @"商品满送";
        _typeLab0.layer.masksToBounds = YES;
        _typeLab0.layer.borderWidth = 1;
        _typeLab0.layer.borderColor = [UIColor hexStringToColor:@"F53F34"].CGColor;
        _typeLab0.layer.cornerRadius = 5;
        _typeLab0.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLab0;
}







@end
