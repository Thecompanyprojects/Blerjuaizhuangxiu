//
//  collectionnewsCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "collectionnewsCell.h"
#import <UIButton+LXMImagePosition.h>
#import "CollectionModel.h"

@interface collectionnewsCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIButton *seeBtn;

@end

@implementation collectionnewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.seeBtn];
       
        [self layout];
    }
    return self;
}

-(void)setdata:(CollectionModel *)model
{
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.nameLab.text = model.trueName;
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.addTime];
    self.contentLab.text = model.designTitle;
    [self.seeBtn setTitle:model.readNum forState:normal];
   
}

-(void)layout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(14);
        make.height.mas_offset(28);
        make.width.mas_offset(28);
    }];
    [weakSelf.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(56);
        make.centerY.equalTo(weakSelf.iconImg);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).with.offset(-14);
        make.centerY.equalTo(weakSelf.iconImg);
    }];
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImg);
        make.width.mas_offset(94);
        make.height.mas_offset(70);
        make.top.equalTo(weakSelf.iconImg.mas_bottom).with.offset(10);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(12);
        make.top.equalTo(weakSelf.leftImg);
        make.right.equalTo(weakSelf).with.offset(-14);
    }];
    [weakSelf.seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(16);
        make.left.equalTo(weakSelf.leftImg.mas_right).with.offset(12);
        make.bottom.equalTo(weakSelf.leftImg);
        make.width.mas_offset(80);
    }];

}

#pragma mark - getters


-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 14;
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor hexStringToColor:@"333333"];
        _nameLab.font = [UIFont systemFontOfSize:15];
    }
    return _nameLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor hexStringToColor:@"999999"];
        _timeLab.font = [UIFont systemFontOfSize:14];
    }
    return _timeLab;
}

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

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc]init];
        _contentLab.textColor = Black_Color;
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 2;
    }
    return _contentLab;
}

-(UIButton *)seeBtn
{
    if(!_seeBtn)
    {
        _seeBtn = [[UIButton alloc] init];
        [_seeBtn setImage:[UIImage imageNamed:@"skimming"] forState:normal];
        _seeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_seeBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_seeBtn setImagePosition:LXMImagePositionLeft spacing:10];
    }
    return _seeBtn;
}









@end
