//
//  localsiteCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localsiteCell.h"
#import <SDAutoLayout.h>
#import <UIButton+LXMImagePosition.h>
#import "localsiteModel.h"

@interface localsiteCell()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *contentlab0;
@property (nonatomic,strong) UILabel *contentlab1;
@property (nonatomic,strong) UIButton *seeBtn;
@property (nonatomic,strong) UIButton *zanBtn;
@end

@implementation localsiteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.contentlab0];
        [self.contentView addSubview:self.contentlab1];
        [self.contentView addSubview:self.seeBtn];
        [self.contentView addSubview:self.zanBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(localsiteModel *)model
{
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.nameLab.text = model.ccShareTitle;
    
    [self.seeBtn setTitle:model.scanCount forState:normal];
    
 
    
    NSString *str1 = @"";
    NSString *str2 = @"";
    NSString *str3 = @"";
    NSString *str4 = @"";
    
    if (IsNilString(model.ccAcreage)) {
        str1 = @"";
    }
    else
    {
        str1 = [NSString stringWithFormat:@"%@%@",model.ccAcreage,@"㎡"];
        //str1 = model.ccAcreage;
    }
    if (IsNilString(model.style)) {
        str2 = @"";
    }
    else
    {
        str2 = model.style;
    }
    if (IsNilString(model.ccAreaName)) {
        str3 = @"";
    }
    else
    {
        str3 = model.ccAreaName;
    }
    if (IsNilString(model.ccShareTitle)) {
        str4 = @"";
    }
    else
    {
        str4 = model.ccHouseholderName;
    }
    self.contentlab0.text = [NSString stringWithFormat:@"%@%@%@",str1,@"/",str2];
    self.contentlab1.text = [NSString stringWithFormat:@"%@%@%@",str3,@" ",str4];
    

    if (model.iszan) {
        [_zanBtn setImage:[UIImage imageNamed:@"support"] forState:normal];
    }
    else
    {
        [_zanBtn setImage:[UIImage imageNamed:@"nosupport"] forState:normal];
    }
    
    [_zanBtn setImagePosition:LXMImagePositionLeft spacing:8];
    [self.zanBtn setTitle:model.likeNumber forState:normal];
    
    [_seeBtn setImage:[UIImage imageNamed:@"skimming"] forState:normal];
    [_seeBtn setImagePosition:LXMImagePositionLeft spacing:8];
    [self.seeBtn setTitle:model.scanCount forState:normal];
    
    [self updateLayout];
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    weakSelf.bgView
    .sd_layout
    .heightIs(250)
    .leftSpaceToView(weakSelf.contentView, 8)
    .rightSpaceToView(weakSelf.contentView, 8)
    .topSpaceToView(weakSelf.contentView, 8);
    
    weakSelf.topImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 14)
    .rightSpaceToView(weakSelf.contentView, 14)
    .heightIs(160);
    
    weakSelf.nameLab
    .sd_layout
    .leftEqualToView(weakSelf.topImg)
    .topSpaceToView(weakSelf.topImg, 14)
    .rightEqualToView(weakSelf.topImg)
    .heightIs(18);
    
    [weakSelf.nameLab setMaxNumberOfLinesToShow:1];
    
    weakSelf.contentlab0
    .sd_layout
    .leftEqualToView(weakSelf.nameLab)
    .topSpaceToView(weakSelf.nameLab, 12)
    .rightEqualToView(weakSelf.nameLab)
    .heightIs(15);
    
    [weakSelf.contentlab0 setMaxNumberOfLinesToShow:1];
    
    weakSelf.contentlab1
    .sd_layout
    .leftEqualToView(weakSelf.nameLab)
    .topSpaceToView(weakSelf.contentlab0, 10)
    .rightEqualToView(weakSelf.nameLab)
    .heightIs(15);
    
    [weakSelf.contentlab1 setMaxNumberOfLinesToShow:1];
    
    weakSelf.zanBtn
    .sd_layout
    .topEqualToView(weakSelf.contentlab1)
    .rightSpaceToView(weakSelf.contentView, 15)
    .widthIs(50)
    .heightIs(15);
    
    weakSelf.seeBtn
    .sd_layout
    .topEqualToView(weakSelf.contentlab1)
    .rightSpaceToView(weakSelf.zanBtn, 15)
    .widthIs(50)
    .heightIs(15);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.bgView bottomMargin:14];
}

#pragma mark - getters


-(UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.contentMode = UIViewContentModeScaleAspectFill;
        _topImg.layer.masksToBounds = YES;
    }
    return _topImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:13];
        
    }
    return _nameLab;
}

-(UILabel *)contentlab0
{
    if(!_contentlab0)
    {
        _contentlab0 = [[UILabel alloc] init];
        _contentlab0.textColor = [UIColor darkGrayColor];
        _contentlab0.font = [UIFont systemFontOfSize:11];
    }
    return _contentlab0;
}

-(UILabel *)contentlab1
{
    if(!_contentlab1)
    {
        _contentlab1 = [[UILabel alloc] init];
        _contentlab1.textColor = [UIColor darkGrayColor];
        _contentlab1.font = [UIFont systemFontOfSize:11];
    }
    return _contentlab1;
}

-(UIButton *)seeBtn
{
    if(!_seeBtn)
    {
        _seeBtn = [[UIButton alloc] init];
        _seeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_seeBtn setTitleColor:[UIColor darkGrayColor] forState:normal];
    }
    return _seeBtn;
}

-(UIButton *)zanBtn
{
    if(!_zanBtn)
    {
        _zanBtn = [[UIButton alloc] init];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_zanBtn setTitleColor:[UIColor darkGrayColor] forState:normal];
        [_zanBtn addTarget:self action:@selector(zanbtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanBtn;
}



#pragma mark - 实现方法

-(void)zanbtnclick
{
    [self.delegate myTabVClick:self];
}





@end
