//
//  panoramicvrCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "panoramicvrCell1.h"
#import "panoramicvrModel.h"
#import <UIButton+LXMImagePosition.h>

@interface panoramicvrCell1()
@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *bottomLab;
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *readBtn;
@end

@implementation panoramicvrCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.bgImg];
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.bottomLab];
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.readBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setdata:(panoramicvrModel *)model
{
    [self.bgImg sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.bottomLab.text = model.picTitle;
    [self.readBtn setTitle:model.displayNumbers forState:normal];
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.addTime];
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(12);
        make.left.equalTo(weakSelf).with.offset(12);
        make.bottom.equalTo(weakSelf).with.offset(-32);
        make.right.equalTo(weakSelf).with.offset(-12);
    }];
    
    [weakSelf.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImg.mas_bottom);
        make.height.mas_offset(15);
        make.left.equalTo(weakSelf.bgImg.mas_left);
        make.right.equalTo(weakSelf.bgImg.mas_right);
    }];
    
    [weakSelf.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImg.mas_bottom);
        make.height.mas_offset(15);
        make.left.equalTo(weakSelf.bgImg.mas_left).with.offset(5);
        make.right.equalTo(weakSelf.bgImg.mas_right).with.offset(-5);
    }];
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(55);
        make.height.mas_offset(55);
        make.top.equalTo(weakSelf.bgImg).with.offset(71);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgImg);
        make.top.equalTo(weakSelf.bgImg.mas_bottom).with.offset(12);
        make.width.mas_offset(80);
    }];
    [weakSelf.readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeLab.mas_right).with.offset(2);
        make.top.equalTo(weakSelf.timeLab);
        make.width.mas_offset(80);
    }];
}

#pragma mark - getters

-(UIImageView *)bgImg
{
    if(!_bgImg)
    {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.contentMode = UIViewContentModeScaleAspectFill;
        _bgImg.layer.masksToBounds = YES;
    }
    return _bgImg;
}

-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor hexStringToColor:@"646464"];
        _bgView.alpha = 0.5;
    }
    return _bgView;
}


-(UILabel *)bottomLab
{
    if(!_bottomLab)
    {
        _bottomLab = [[UILabel alloc] init];
        _bottomLab.font = [UIFont systemFontOfSize:12];
        _bottomLab.textColor = White_Color;
        
    }
    return _bottomLab;
}

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"quanjinganniu"];
    }
    return _img;
}


-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor hexStringToColor:@"777777"];
    }
    return _timeLab;
}

-(UIButton *)readBtn
{
    if(!_readBtn)
    {
        _readBtn = [[UIButton alloc] init];

        _readBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_readBtn setTitleColor:[UIColor hexStringToColor:@"777777"] forState:normal];
        [_readBtn setImagePosition:LXMImagePositionLeft spacing:4];
        [_readBtn setImage:[UIImage imageNamed:@"skimming"] forState:normal];
    }
    return _readBtn;
}



@end
