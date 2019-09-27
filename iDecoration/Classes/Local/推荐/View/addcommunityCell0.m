//
//  addcommunityCell0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "addcommunityCell0.h"

@interface addcommunityCell0()

@end

@implementation addcommunityCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bgImg];
        [self.contentView addSubview:self.addBtn];
        [self.contentView addSubview:self.contentLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(44);
        make.left.equalTo(weakSelf).with.offset(50);
        make.right.equalTo(weakSelf).with.offset(-50);
        make.height.mas_offset(140);
    }];
    [weakSelf.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgImg);
        make.centerY.equalTo(weakSelf.bgImg);
        make.width.mas_offset(47);
        make.height.mas_offset(47);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.bgImg.mas_bottom).with.offset(14);
        make.height.mas_offset(16);
        make.left.equalTo(weakSelf).with.offset(12);
    }];
}

#pragma mark - getters

-(UIImageView *)bgImg
{
    if(!_bgImg)
    {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.layer.masksToBounds = YES;
        _bgImg.layer.borderWidth = 0.5;
        _bgImg.layer.borderColor = [UIColor hexStringToColor:@"999999"].CGColor;
    }
    return _bgImg;
}

-(UIButton *)addBtn
{
    if(!_addBtn)
    {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"addmanmadf"] forState:normal];
    }
    return _addBtn;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.text = @"上传户型图";
        _contentLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _contentLab;
}



@end
