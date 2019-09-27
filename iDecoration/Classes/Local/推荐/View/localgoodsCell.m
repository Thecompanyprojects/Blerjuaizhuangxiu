//
//  localgoodsCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localgoodsCell.h"
#import "localgoodsModel.h"

@interface localgoodsCell()
@property (nonatomic,strong) UIImageView *goodsImg;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation localgoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.goodsImg];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.moneyLab];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(localgoodsModel *)model
{
    [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.faceImg]];
    self.contentLab.text = model.name?:@"";
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"￥",model.price]?:@"";
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.goodsImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(7);
        make.top.equalTo(weakSelf).with.offset(13);
        make.right.equalTo(weakSelf).with.offset(-7);
        make.height.mas_offset(110);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsImg);
        make.right.equalTo(weakSelf.goodsImg);
        make.top.equalTo(weakSelf.goodsImg.mas_bottom).with.offset(8);
    }];
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsImg);
        make.right.equalTo(weakSelf.goodsImg);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(6);
    }];
}

#pragma mark - getters

-(UIImageView *)goodsImg
{
    if(!_goodsImg)
    {
        _goodsImg = [[UIImageView alloc] init];
        _goodsImg.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImg.layer.masksToBounds = YES;
    }
    return _goodsImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 2;
        _contentLab.textColor = [UIColor hexStringToColor:@"333333"];
        _contentLab.font = [UIFont systemFontOfSize:13];
       // _contentLab.text = @"选购主材硬装  现代简约板 式床  高箱储物的空间储...选购主材硬装  现代简约板 式床  高箱储物的空间储...";
    }
    return _contentLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textColor = [UIColor hexStringToColor:@"DF1515"];
        _moneyLab.font = [UIFont systemFontOfSize:13];
        //_moneyLab.text = @"¥187";
    }
    return _moneyLab;
}




@end
