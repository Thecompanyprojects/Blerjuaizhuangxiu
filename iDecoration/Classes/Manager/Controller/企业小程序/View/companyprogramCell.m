//
//  companyprogramCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "companyprogramCell.h"

@interface companyprogramCell()

@end

@implementation companyprogramCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.nameLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(22);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(45);
        make.height.mas_offset(45);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(26);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-24);
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
        _nameLab.font = [UIFont systemFontOfSize:17];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _nameLab;
}

@end
