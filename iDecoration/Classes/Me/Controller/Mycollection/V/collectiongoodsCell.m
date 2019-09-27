//
//  collectiongoodsCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "collectiongoodsCell.h"
#import "CollectionModel.h"

@interface collectiongoodsCell()
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *moneyLab;
@end

@implementation collectiongoodsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.moneyLab];
        [self layout];
    }
    return self;
}

-(void)layout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(92);
        make.height.mas_offset(92);
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.top.equalTo(weakSelf.leftImg);
    }];
    [weakSelf.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentLab);
        make.height.mas_offset(20);
        make.bottom.equalTo(weakSelf.leftImg);
    }];
}

-(void)setdata:(CollectionModel *)model
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.faceImg]];
    self.contentLab.text = model.name;
    self.moneyLab.text = [NSString stringWithFormat:@"%@%@",@"¥",model.price];
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

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = [UIColor hexStringToColor:@"000000"];
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}

-(UILabel *)moneyLab
{
    if(!_moneyLab)
    {
        _moneyLab = [[UILabel alloc] init];
        _moneyLab.textColor = [UIColor hexStringToColor:@"FB3109"];
        _moneyLab.font = [UIFont systemFontOfSize:13];
    }
    return _moneyLab;
}

@end
