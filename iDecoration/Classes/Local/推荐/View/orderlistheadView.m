//
//  orderlistheadView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "orderlistheadView.h"
#import "rankingModel.h"

@interface orderlistheadView()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIImageView *icomImg;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;
@property (nonatomic,strong) UILabel *nameLab;
@end

@implementation orderlistheadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.bgImg];
        [self addSubview:self.icomImg];
        [self addSubview:self.leftLab];
        [self addSubview:self.rightLab];
        [self addSubview:self.nameLab];
        [self layoutUI];
    }
    return self;
}

-(void)layoutUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_offset(50);
    }];
    [weakSelf.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(5);
        make.left.equalTo(weakSelf).with.offset(10);
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(120);
    }];
    [weakSelf.icomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImg).with.offset(24);
        make.width.mas_offset(35);
        make.height.mas_offset(35);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(30);
        make.top.equalTo(weakSelf).with.offset(49);
    }];
    [weakSelf.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-30);
        make.top.equalTo(weakSelf).with.offset(49);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.icomImg.mas_bottom).with.offset(10);
    }];
}

-(void)setdata:(rankingModel *)model
{
    [self.icomImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    if (IsNilString(model.counts)) {
        self.rightLab.text = [NSString stringWithFormat:@"%@%@",@"0",@"人"];
    }
    else
    {
        self.rightLab.text = [NSString stringWithFormat:@"%@%@",model.counts,@"人"];
    }
    
    self.nameLab.text = model.companyName;
}

#pragma mark - getters

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor hexStringToColor:@"4ABD87"];
    }
    return _bgView;
}


-(UIImageView *)bgImg
{
    if(!_bgImg)
    {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"headbgimg"];
    }
    return _bgImg;
}


-(UIImageView *)icomImg
{
    if(!_icomImg)
    {
        _icomImg = [[UIImageView alloc] init];
        _icomImg.layer.masksToBounds = YES;
        _icomImg.layer.cornerRadius = 35/2;
        
    }
    return _icomImg;
}

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textColor = [UIColor hexStringToColor:@"FE8104"];
        _leftLab.font = [UIFont fontWithName:@"TektonPro-BoldCond" size:21.5];
        _leftLab.text = @"NO.1";
    }
    return _leftLab;
}

-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.textColor = [UIColor hexStringToColor:@"FE8104"];
        _rightLab.font = [UIFont fontWithName:@"TektonPro-BoldCond" size:21.5];
    }
    return _rightLab;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentCenter;
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
        
    }
    return _nameLab;
}

@end
