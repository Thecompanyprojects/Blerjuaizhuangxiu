
//
//  localCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localCell2.h"
#import "localshopView0.h"
#import "localshopView1.h"
#import "localgoodModel.h"


@interface localCell2()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) localshopView0 *shopView0;
@property (nonatomic,strong) localshopView0 *shopView1;
@property (nonatomic,strong) localshopView1 *shopView2;
@property (nonatomic,strong) localshopView1 *shopView3;
@property (nonatomic,strong) localshopView1 *shopView4;
@property (nonatomic,strong) localshopView1 *shopView5;
@property (nonatomic,strong) NSMutableArray *goodsArray;
@end

@implementation localCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.shopView0];
        [self.contentView addSubview:self.shopView1];
        [self.contentView addSubview:self.shopView2];
        [self.contentView addSubview:self.shopView3];
        [self.contentView addSubview:self.shopView4];
        [self.contentView addSubview:self.shopView5];
        [self.contentView addSubview:self.moreBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(NSMutableArray *)arr
{
    self.goodsArray = [NSMutableArray array];
    self.goodsArray = arr;
    if (arr.count>=1) {
        localgoodModel *model0 = [arr firstObject];
        [self.shopView0.shopImg sd_setImageWithURL:[NSURL URLWithString:model0.faceImg] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.shopView0.nameLab.text = model0.name?:@"";
    }
    if (arr.count>=2) {
        localgoodModel *model1 = [arr objectAtIndex:1];
        [self.shopView1.shopImg sd_setImageWithURL:[NSURL URLWithString:model1.faceImg] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.shopView1.nameLab.text = model1.name?:@"";
    }
    if (arr.count>=3) {
        localgoodModel *model2 = [arr objectAtIndex:2];
        [self.shopView2.shopImg sd_setImageWithURL:[NSURL URLWithString:model2.faceImg] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.shopView2.nameLab.text = model2.name?:@"";
        self.shopView2.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model2.price?:@"0"];
    }
    if (arr.count>=4) {
        localgoodModel *model3 = [arr objectAtIndex:3];
        [self.shopView3.shopImg sd_setImageWithURL:[NSURL URLWithString:model3.faceImg] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.shopView3.nameLab.text = model3.name?:@"";
        self.shopView3.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model3.price?:@"0"];
    }
    if (arr.count>=5) {
        localgoodModel *model4 = [arr objectAtIndex:4];
        [self.shopView4.shopImg sd_setImageWithURL:[NSURL URLWithString:model4.faceImg] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.shopView4.nameLab.text = model4.name?:@"";
        self.shopView4.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model4.price?:@"0"];
    }
    if (arr.count==6) {
        localgoodModel *model5 = [arr objectAtIndex:5];
        [self.shopView5.shopImg sd_setImageWithURL:[NSURL URLWithString:model5.faceImg] placeholderImage:[UIImage imageNamed:@"timg"]];
        self.shopView5.nameLab.text = model5.name?:@"";
        self.shopView5.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model5.price?:@"0"];
    }
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(29);
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(91);
        make.height.mas_offset(16);
    }];
    [weakSelf.shopView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(13);
        make.left.equalTo(weakSelf).with.offset(10);
        make.height.mas_offset(105);
        make.width.mas_offset(206);
    }];
    [weakSelf.shopView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.shopView0);
        make.left.equalTo(weakSelf.shopView0.mas_right);
        make.right.equalTo(weakSelf).with.offset(-10);
        make.height.mas_offset(105);
    }];
    
    [weakSelf.shopView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopView0);
        make.top.equalTo(weakSelf.shopView0.mas_bottom);
        make.width.mas_offset(89);
        make.height.mas_offset(120);
    }];
    [weakSelf.shopView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopView2.mas_right);
        make.width.mas_offset(89);
        make.height.mas_offset(120);
        make.top.equalTo(weakSelf.shopView2);
    }];
    [weakSelf.shopView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.shopView1);
        make.width.mas_offset(89);
        make.height.mas_offset(120);
        make.top.equalTo(weakSelf.shopView2);
    }];
    [weakSelf.shopView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.shopView2);
        make.right.equalTo(weakSelf.shopView5.mas_left);
        make.width.mas_offset(89);
        make.height.mas_offset(120);
    }];
    [weakSelf.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.shopView4.mas_bottom).with.offset(14);
        make.width.mas_offset(94);
        make.height.mas_offset(19);
    }];
    
}
#pragma mark - getters

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [UIImage imageNamed:@"icon_shangchengyoup"];
    }
    return _topImg;
}

-(localshopView0 *)shopView0
{
    if(!_shopView0)
    {
        _shopView0 = [[localshopView0 alloc] init];
        _shopView0.shopImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick0)];
        [_shopView0 addGestureRecognizer:tapGesturRecognizer];
    }
    return _shopView0;
}

-(localshopView0 *)shopView1
{
    if(!_shopView1)
    {
        _shopView1 = [[localshopView0 alloc] init];
        _shopView1.shopImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick1)];
        [_shopView1 addGestureRecognizer:tapGesturRecognizer];
    }
    return _shopView1;
}

-(localshopView1 *)shopView2
{
    if(!_shopView2)
    {
        _shopView2 = [[localshopView1 alloc] init];
        _shopView2.shopImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick2)];
        [_shopView2 addGestureRecognizer:tapGesturRecognizer];
    }
    return _shopView2;
}

-(localshopView1 *)shopView3
{
    if(!_shopView3)
    {
        _shopView3 = [[localshopView1 alloc] init];
        _shopView3.shopImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick3)];
        [_shopView3 addGestureRecognizer:tapGesturRecognizer];
    }
    return _shopView3;
}

-(localshopView1 *)shopView4
{
    if(!_shopView4)
    {
        _shopView4 = [[localshopView1 alloc] init];
        _shopView4.shopImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick4)];
        [_shopView4 addGestureRecognizer:tapGesturRecognizer];
    }
    return _shopView4;
}

-(localshopView1 *)shopView5
{
    if(!_shopView5)
    {
        _shopView5 = [[localshopView1 alloc] init];
        _shopView5.shopImg.image = [UIImage imageNamed:@"timg"];
        UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectclick5)];
        [_shopView5 addGestureRecognizer:tapGesturRecognizer];
    }
    return _shopView5;
}

-(UIButton *)moreBtn
{
    if(!_moreBtn)
    {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.layer.masksToBounds = YES;
        _moreBtn.layer.borderColor = [UIColor hexStringToColor:@"DDDDDD"].CGColor;
        _moreBtn.layer.borderWidth = 0.5f;
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreBtn setTitleColor:[UIColor hexStringToColor:@"777777"] forState:normal];
        [_moreBtn setTitle:@"更多特卖产品>" forState:normal];
        _moreBtn.layer.cornerRadius = 9;
    }
    return _moreBtn;
}


-(void)selectclick0
{
    if (self.goodsArray.count>=1) {
        localgoodModel *model = [self.goodsArray firstObject];
        [self.delegate mygoods:model];
    }
}

-(void)selectclick1
{
    if (self.goodsArray.count>=2) {
        localgoodModel *model = [self.goodsArray objectAtIndex:1];
        [self.delegate mygoods:model];
    }
}

-(void)selectclick2
{
    if (self.goodsArray.count>=3) {
        localgoodModel *model = [self.goodsArray objectAtIndex:2];
        [self.delegate mygoods:model];
    }
}

-(void)selectclick3
{
    if (self.goodsArray.count>=4) {
        localgoodModel *model = [self.goodsArray objectAtIndex:3];
        [self.delegate mygoods:model];
    }
}

-(void)selectclick4
{
    if (self.goodsArray.count>=5) {
        localgoodModel *model = [self.goodsArray objectAtIndex:4];
        [self.delegate mygoods:model];
    }
}

-(void)selectclick5
{
    if (self.goodsArray.count>=6) {
        localgoodModel *model = [self.goodsArray objectAtIndex:5];
        [self.delegate mygoods:model];
    }
}



@end
