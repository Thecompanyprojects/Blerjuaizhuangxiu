//
//  localnotesCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localnotesCell.h"
#import <SDAutoLayout.h>
#import <UIButton+LXMImagePosition.h>
#import "localnotesModel.h"

@interface localnotesCell()
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *bigImg;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@end

@implementation localnotesCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.bigImg];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.btn1];
        [self.contentView addSubview:self.btn0];
        [self.contentView addSubview:self.btn2];
        [self setuplauout];
    }
    return self;
}


-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;

    weakSelf.iconImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 14)
    .widthIs(32)
    .heightIs(32);
    
    weakSelf.nameLab
    .sd_layout
    .leftSpaceToView(weakSelf.iconImg, 15)
    .centerYEqualToView(weakSelf.iconImg)
    .heightIs(20)
    .widthIs(200);
    
    weakSelf.timeLab
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 14)
    .centerYEqualToView(weakSelf.iconImg)
    .heightIs(20)
    .widthIs(120);
    
    weakSelf.contentLab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 20)
    .rightSpaceToView(weakSelf.contentView, 20)
    .topSpaceToView(weakSelf.iconImg, 14)
    .autoHeightRatio(0);

    [weakSelf.contentLab setMaxNumberOfLinesToShow:2];
    
    weakSelf.bigImg
    .sd_layout
    .leftEqualToView(weakSelf.contentLab)
    .rightEqualToView(weakSelf.contentLab)
    .heightIs(188)
    .topSpaceToView(weakSelf.contentLab, 14);
    
    weakSelf.line
    .sd_layout
    .leftSpaceToView(self.contentView, 17)
    .rightSpaceToView(self.contentView, 17)
    .heightIs(1)
    .topSpaceToView(self.bigImg, 10);
    
    weakSelf.btn1
    .sd_layout
    .centerXEqualToView(self.contentView)
    .widthIs(50)
    .heightIs(28)
    .topSpaceToView(self.line, 10);
    
    weakSelf.btn0
    .sd_layout
    .leftSpaceToView(self.contentView, 44)
    .widthIs(50)
    .heightIs(28)
    .topSpaceToView(self.line, 10);
    
    weakSelf.btn2
    .sd_layout
    .rightSpaceToView(self.contentView, 44)
    .widthIs(50)
    .heightIs(28)
    .topSpaceToView(self.line, 10);
    
    [weakSelf setupAutoHeightWithBottomView:_btn1 bottomMargin:10];
}

-(void)setdata:(localnotesModel *)model
{
    if (model.iszan) {
        [_btn2 setImage:[UIImage imageNamed:@"赞2"] forState:normal];
    }
    else
    {
        [_btn2 setImage:[UIImage imageNamed:@"赞"] forState:normal];
    }
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
    self.nameLab.text = model.companyName;
    self.contentLab.text = model.designTitle;
//    NSString *imgurl = [model.imgs firstObject];
    self.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.addTime];
    [self.bigImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    [self.btn2 setTitle:[NSString stringWithFormat:@"%ld",model.likeNum] forState:normal];
    [self.btn1 setTitle:[NSString stringWithFormat:@"%ld",model.messageCount] forState:normal];
    [self.btn0 setTitle:[NSString stringWithFormat:@"%@",model.share] forState:normal];
}

#pragma mark - getters

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 16;
        
    }
    return _iconImg;
}

-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:15];
        _nameLab.textColor = [UIColor hexStringToColor:@"000000"];
    }
    return _nameLab;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor hexStringToColor:@"989898"];
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor hexStringToColor:@"343434"];
        _contentLab.numberOfLines = 2;
        _contentLab.text = @"测试测试测试";
    }
    return _contentLab;
}


-(UIImageView *)bigImg
{
    if(!_bigImg)
    {
        _bigImg = [[UIImageView alloc] init];
        _bigImg.contentMode = UIViewContentModeScaleAspectFill;
        _bigImg.layer.masksToBounds = YES;
    }
    return _bigImg;
}

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    }
    return _line;
}

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setImage:[UIImage imageNamed:@"转发"] forState:normal];
        [_btn0 setTitle:@"111" forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn0 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_btn0 setImagePosition:LXMImagePositionLeft spacing:10];
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setImage:[UIImage imageNamed:@"评论(2)"] forState:normal];
        [_btn1 setTitle:@"22" forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn1 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_btn1 setImagePosition:LXMImagePositionLeft spacing:10];
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setImage:[UIImage imageNamed:@"赞"] forState:normal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:13];
        [_btn2 setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_btn2 setImagePosition:LXMImagePositionLeft spacing:10];
        [_btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}


#pragma mark - 实现方法

-(void)btn0click
{
    [self.delegate myTabVClick0:self];
}

-(void)btn1click
{
    [self.delegate myTabVClick1:self];
}

-(void)btn2click
{
    [self.delegate myTabVClick2:self];
}

@end
