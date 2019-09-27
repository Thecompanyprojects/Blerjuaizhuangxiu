//
//  attentiondetailsCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "attentiondetailsCell.h"
#import <SDAutoLayout.h>
#import <UIButton+LXMImagePosition.h>
#import "attentionModel.h"

@interface attentiondetailsCell()
@property (nonatomic,strong) UIView *fengeView;

@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *contentLab0;
@property (nonatomic,strong) UILabel *contentLab1;
@property (nonatomic,strong) UIImageView *rightimg;
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@property (nonatomic,strong) UIImageView *img2;
@property (nonatomic,strong) UIImageView *bigimg;
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UIImageView *vipImg0;
@property (nonatomic,strong) UIImageView *vipImg1;
@property (nonatomic,strong) UIButton *guanzhuBtn;
@property (nonatomic,strong) UIImageView *renzhenImg;
@end

@implementation attentiondetailsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.fengeView];
        [self.contentView addSubview:self.iconImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        
        [self.contentView addSubview:self.rightimg];
        [self.contentView addSubview:self.contentLab0];
        
        [self.contentView addSubview:self.contentLab1];
        [self.contentView addSubview:self.bigimg];
        
        [self.contentView addSubview:self.leftImg];
        
        [self.contentView addSubview:self.img0];
        [self.contentView addSubview:self.img1];
        [self.contentView addSubview:self.img2];
        
        [self.contentView addSubview:self.line];

        
        [self.contentView addSubview:self.vipImg0];
        [self.contentView addSubview:self.vipImg1];
        [self.contentView addSubview:self.guanzhuBtn];
        [self.contentView addSubview:self.renzhenImg];
        
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    weakSelf.fengeView
    .sd_layout
    .leftEqualToView(weakSelf.contentView)
    .rightEqualToView(weakSelf.contentView)
    .heightIs(4)
    .topEqualToView(weakSelf.contentView);
    
    weakSelf.guanzhuBtn
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 10)
    .topSpaceToView(weakSelf.contentView, 20)
    .widthIs(40)
    .heightIs(20);
}

#pragma mark - getters


-(UIView *)fengeView
{
    if(!_fengeView)
    {
        _fengeView = [[UIView alloc] init];
        _fengeView.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    }
    return _fengeView;
}

-(UIImageView *)iconImg
{
    if(!_iconImg)
    {
        _iconImg = [[UIImageView alloc] init];
        _iconImg.layer.masksToBounds = YES;
        _iconImg.layer.cornerRadius = 18;
    }
    return _iconImg;
}


-(UILabel *)nameLab
{
    if(!_nameLab)
    {
        _nameLab = [[UILabel alloc] init];
        _nameLab.text = @"nametext";
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
        
    }
    return _timeLab;
}

-(UILabel *)contentLab0
{
    if(!_contentLab0)
    {
        _contentLab0 = [[UILabel alloc] init];
        _contentLab0.font = [UIFont systemFontOfSize:13];
        _contentLab0.textColor = [UIColor hexStringToColor:@"343434"];
        _contentLab0.numberOfLines = 2;
    }
    return _contentLab0;
}

-(UILabel *)contentLab1
{
    if(!_contentLab1)
    {
        _contentLab1 = [[UILabel alloc] init];
        _contentLab1.font = [UIFont systemFontOfSize:13];
        _contentLab1.textColor = [UIColor hexStringToColor:@"343434"];
        _contentLab1.numberOfLines = 2;
    }
    return _contentLab1;
}


-(UIImageView *)rightimg
{
    if(!_rightimg)
    {
        _rightimg = [[UIImageView alloc] init];
        _rightimg.contentMode = UIViewContentModeScaleAspectFill;
        _rightimg.layer.masksToBounds = YES;
    }
    return _rightimg;
}


-(UIImageView *)bigimg
{
    if(!_bigimg)
    {
        _bigimg = [[UIImageView alloc] init];
        _bigimg.contentMode = UIViewContentModeScaleAspectFill;
        _bigimg.layer.masksToBounds = YES;
    }
    return _bigimg;
}


-(UIImageView *)img0
{
    if(!_img0)
    {
        _img0 = [[UIImageView alloc] init];
        _img0.contentMode = UIViewContentModeScaleAspectFill;
        _img0.layer.masksToBounds = YES;
    }
    return _img0;
}


-(UIImageView *)img1
{
    if(!_img1)
    {
        _img1 = [[UIImageView alloc] init];
        _img1.contentMode = UIViewContentModeScaleAspectFill;
        _img1.layer.masksToBounds = YES;
    }
    return _img1;
}


-(UIImageView *)img2
{
    if(!_img2)
    {
        _img2 = [[UIImageView alloc] init];
        _img2.contentMode = UIViewContentModeScaleAspectFill;
        _img2.layer.masksToBounds = YES;
    }
    return _img2;
}


-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
        _leftImg.layer.masksToBounds = YES;
    }
    return _leftImg;
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

-(UIImageView *)vipImg0
{
    if(!_vipImg0)
    {
        _vipImg0 = [[UIImageView alloc] init];
        _vipImg0.image = [UIImage imageNamed:@"zhuanshi"];
    }
    return _vipImg0;
}


-(UIImageView *)vipImg1
{
    if(!_vipImg1)
    {
        _vipImg1 = [[UIImageView alloc] init];
        _vipImg1.image = [UIImage imageNamed:@"vip1"];
    }
    return _vipImg1;
}



-(UIButton *)guanzhuBtn
{
    if(!_guanzhuBtn)
    {
        _guanzhuBtn = [[UIButton alloc] init];
        // [_guanzhuBtn setImage:[UIImage imageNamed:@"local_guanzhu"] forState:normal];
        [_guanzhuBtn addTarget:self action:@selector(btn3click)
              forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _guanzhuBtn;
}




-(UIImageView *)renzhenImg
{
    if(!_renzhenImg)
    {
        _renzhenImg = [[UIImageView alloc] init];
        _renzhenImg.image = [UIImage imageNamed:@"renzheng_local"];
    }
    return _renzhenImg;
}

-(void)setdata:(attentionModel *)model
{

    
    //消息的类型0：美文1：活动2：商品3：工地  3：美文4：活动5：商品1：工地
    if (model.type==3||model.type==4) {
        [self.renzhenImg setHidden:YES];
        [self.guanzhuBtn setHidden:YES];
        
        NSArray *array = [model.picture1 componentsSeparatedByString:@","];
        if (array.count<3) {
            [self.img0 setHidden:YES];
            [self.img1 setHidden:YES];
            [self.img2 setHidden:YES];
            [self.contentLab1 setHidden:YES];
            [self.bigimg setHidden:YES];
            [self.leftImg setHidden:YES];
            [self.rightimg setHidden:NO];
            [self.contentLab0 setHidden:NO];
            [self.iconImg setHidden:NO];
            
            
            
            self.iconImg
            .sd_layout
            .leftSpaceToView(self.contentView, 20)
            .topSpaceToView(self.contentView, 20)
            .widthIs(36)
            .heightIs(36);
            
            
            self.nameLab
            .sd_layout
            .leftSpaceToView(self.iconImg, 11)
            .heightIs(20)
            .topEqualToView(self.iconImg);
            
            [self.nameLab setSingleLineAutoResizeWithMaxWidth:(140)];
            
            if (model.recommendVip==1) {
                
                self.vipImg0
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 35)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                [self.vipImg0 setHidden:NO];
                [self.vipImg1 setHidden:NO];
            }
            else
            {
                [self.vipImg0 setHidden:YES];
                [self.vipImg1 setHidden:NO];
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
            }
            
            self.timeLab
            .sd_layout
            .leftEqualToView(self.nameLab)
            .topSpaceToView(self.nameLab, 7)
            .autoHeightRatio(0)
            .rightSpaceToView(self.contentView, 20);
            
            self.rightimg
            .sd_layout
            .rightSpaceToView(self.contentView, 20)
            .widthIs(114)
            .heightIs(75)
            .topSpaceToView(self.iconImg, 20);
            
            self.contentLab0
            .sd_layout
            .leftSpaceToView(self.contentView, 14)
            .rightSpaceToView(self.rightimg, 14)
            .topEqualToView(self.rightimg)
            .autoHeightRatio(0);
            
            [self.contentLab0 setMaxNumberOfLinesToShow:2];
            
            self.line
            .sd_layout
            .leftSpaceToView(self.contentView, 17)
            .rightSpaceToView(self.contentView, 17)
            .heightIs(1)
            .topSpaceToView(self.rightimg, 15);
            
         
            
            NSString *urlimg = [array firstObject];
            self.contentLab0.text = model.content;
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
            
            
            if (model.companyName.length>8) {
                NSString *subString1 = [model.companyName substringToIndex:7];
                NSString *subString2 = @"...";
                NSString *str = [subString1 stringByAppendingString:subString2];
                
                self.nameLab.text = str;
            }
            else
            {
                self.nameLab.text = model.companyName;
            }
            [self.rightimg sd_setImageWithURL:[NSURL URLWithString:urlimg]];
            
            
            [self setupAutoHeightWithBottomView:self.line bottomMargin:0.01];
            [self updateLayout];
        }
        else
        {
            [self.contentLab0 setHidden:YES];
            [self.contentLab1 setHidden:NO];
            [self.bigimg setHidden:YES];
            [self.leftImg setHidden:YES];
            [self.rightimg setHidden:YES];
            [self.iconImg setHidden:NO];
            [self.timeLab setHidden:NO];
            [self.nameLab setHidden:NO];
            [self.img0 setHidden:NO];
            [self.img1 setHidden:NO];
            [self.img2 setHidden:NO];
            [self.iconImg setHidden:NO];
            
            self.iconImg
            .sd_layout
            .leftSpaceToView(self.contentView, 20)
            .topSpaceToView(self.contentView, 20)
            .widthIs(36)
            .heightIs(36);
            
            self.nameLab
            .sd_layout
            .leftSpaceToView(self.iconImg, 11)
            .heightIs(20)
            .topEqualToView(self.iconImg);
            
            [self.nameLab setSingleLineAutoResizeWithMaxWidth:(140)];
            
            if (model.recommendVip==1) {
                
                self.vipImg0
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 35)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                [self.vipImg0 setHidden:NO];
                [self.vipImg1 setHidden:NO];
            }
            else
            {
                [self.vipImg0 setHidden:YES];
                [self.vipImg1 setHidden:NO];
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
            }
            
            self.timeLab
            .sd_layout
            .leftEqualToView(self.nameLab)
            .topSpaceToView(self.nameLab, 7)
            .autoHeightRatio(0)
            .rightSpaceToView(self.contentView, 20);
            
            
            self.contentLab1
            .sd_layout
            .leftSpaceToView(self.contentView, 14)
            .rightSpaceToView(self.contentView, 14)
            .topSpaceToView(self.iconImg, 20)
            .autoHeightRatio(0);
            
            
            self.img1
            .sd_layout
            .centerXEqualToView(self.contentView)
            .widthIs(112)
            .heightIs(75)
            .topSpaceToView(self.contentLab1, 15);
            
            self.img0
            .sd_layout
            .rightSpaceToView(self.img1, 10)
            .topEqualToView(self.img1)
            .widthIs(112)
            .heightIs(75);
            
            self.img2
            .sd_layout
            .leftSpaceToView(self.img1, 10)
            .topEqualToView(self.img1)
            .widthIs(112)
            .heightIs(75);
            
            self.line
            .sd_layout
            .leftSpaceToView(self.contentView, 17)
            .rightSpaceToView(self.contentView, 17)
            .heightIs(1)
            .topSpaceToView(self.img0, 10);
            
     
            
            self.contentLab1.text = model.content;
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
            
            if (model.companyName.length>8) {
                NSString *subString1 = [model.companyName substringToIndex:7];
                NSString *subString2 = @"...";
                NSString *str = [subString1 stringByAppendingString:subString2];
                
                self.nameLab.text = str;
            }
            else
            {
                self.nameLab.text = model.companyName;
            }
            NSString *urlimg0 = [array firstObject];
            NSString *urlimg1 = [array objectAtIndex:1];
            NSString *urlimg2 = [array objectAtIndex:2];
            [self.img0 sd_setImageWithURL:[NSURL URLWithString:urlimg0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:urlimg1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:urlimg2]];
            
            [self setupAutoHeightWithBottomView:self.line bottomMargin:0.01];
            [self updateLayout];
        }
        
    }
    if (model.type==5) {
        NSArray *array = [model.picture1 componentsSeparatedByString:@","];
        
        [self.renzhenImg setHidden:YES];
        [self.guanzhuBtn setHidden:YES];
        if (array.count<3) {
            [self.img0 setHidden:YES];
            [self.img1 setHidden:YES];
            [self.img2 setHidden:YES];
            [self.contentLab1 setHidden:NO];
            [self.bigimg setHidden:NO];
            [self.leftImg setHidden:YES];
            [self.rightimg setHidden:YES];
            [self.contentLab0 setHidden:YES];
            [self.iconImg setHidden:NO];
            
            self.iconImg
            .sd_layout
            .leftSpaceToView(self.contentView, 20)
            .topSpaceToView(self.contentView, 20)
            .widthIs(36)
            .heightIs(36);
            
            self.nameLab
            .sd_layout
            .leftSpaceToView(self.iconImg, 11)
            .heightIs(20)
            .topEqualToView(self.iconImg);
            
            
            [self.nameLab setSingleLineAutoResizeWithMaxWidth:(140)];
            
            if (model.recommendVip==1) {
                
                self.vipImg0
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 35)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                [self.vipImg0 setHidden:NO];
                [self.vipImg1 setHidden:NO];
            }
            else
            {
                [self.vipImg0 setHidden:YES];
                [self.vipImg1 setHidden:NO];
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
            }
            
            self.timeLab
            .sd_layout
            .leftEqualToView(self.nameLab)
            .topSpaceToView(self.nameLab, 7)
            .autoHeightRatio(0)
            .rightSpaceToView(self.contentView, 20);
            
            
            
            self.contentLab1
            .sd_layout
            .leftSpaceToView(self.contentView, 14)
            .rightSpaceToView(self.contentView, 14)
            .topSpaceToView(self.iconImg, 20)
            .autoHeightRatio(0);
            
            
            self.bigimg
            .sd_layout
            .leftEqualToView(self.contentLab1)
            .rightEqualToView(self.contentLab1)
            .topSpaceToView(self.contentLab1, 11)
            .heightIs(158);
            
            
            [self.contentLab1 setMaxNumberOfLinesToShow:2];
            
            self.line
            .sd_layout
            .leftSpaceToView(self.contentView, 17)
            .rightSpaceToView(self.contentView, 17)
            .heightIs(1)
            .topSpaceToView(self.bigimg, 10);
            
      
            
            NSString *urlimg = [array firstObject];
            self.contentLab1.text = model.content;
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
            // self.nameLab.text = model.companyName;
            
            if (model.companyName.length>8) {
                NSString *subString1 = [model.companyName substringToIndex:7];
                NSString *subString2 = @"...";
                NSString *str = [subString1 stringByAppendingString:subString2];
                
                self.nameLab.text = str;
            }
            else
            {
                self.nameLab.text = model.companyName;
            }
            [self.bigimg sd_setImageWithURL:[NSURL URLWithString:urlimg]];
            
            [self setupAutoHeightWithBottomView:self.line bottomMargin:0.01f];
            [self updateLayout];
        }
        else
        {
            [self.contentLab0 setHidden:YES];
            [self.contentLab1 setHidden:NO];
            [self.bigimg setHidden:YES];
            [self.leftImg setHidden:YES];
            [self.rightimg setHidden:YES];
            [self.iconImg setHidden:NO];
            [self.timeLab setHidden:NO];
            [self.nameLab setHidden:NO];
            [self.img0 setHidden:NO];
            [self.img1 setHidden:NO];
            [self.img2 setHidden:NO];
            [self.iconImg setHidden:NO];
            
            self.iconImg
            .sd_layout
            .leftSpaceToView(self.contentView, 20)
            .topSpaceToView(self.contentView, 20)
            .widthIs(36)
            .heightIs(36);
            
            self.nameLab
            .sd_layout
            .leftSpaceToView(self.iconImg, 11)
            .heightIs(20)
            .topEqualToView(self.iconImg);
            
            [self.nameLab setSingleLineAutoResizeWithMaxWidth:(140)];
            
            if (model.recommendVip==1) {
                
                self.vipImg0
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 35)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
                [self.vipImg0 setHidden:NO];
                [self.vipImg1 setHidden:NO];
            }
            else
            {
                [self.vipImg0 setHidden:YES];
                [self.vipImg1 setHidden:NO];
                
                self.vipImg1
                .sd_layout
                .leftSpaceToView(self.nameLab, 15)
                .centerYEqualToView(self.nameLab)
                .widthIs(15)
                .heightIs(15);
                
            }
            
            self.timeLab
            .sd_layout
            .leftEqualToView(self.nameLab)
            .topSpaceToView(self.nameLab, 7)
            .autoHeightRatio(0)
            .rightSpaceToView(self.contentView, 20);
            
            
            self.contentLab1
            .sd_layout
            .leftSpaceToView(self.contentView, 14)
            .rightSpaceToView(self.contentView, 14)
            .topSpaceToView(self.iconImg, 20)
            .autoHeightRatio(0);
            
            
            self.img1
            .sd_layout
            .centerXEqualToView(self.contentView)
            .widthIs(112)
            .heightIs(75)
            .topSpaceToView(self.contentLab1, 15);
            
            self.img0
            .sd_layout
            .rightSpaceToView(self.img1, 10)
            .topEqualToView(self.img1)
            .widthIs(112)
            .heightIs(75);
            
            self.img2
            .sd_layout
            .leftSpaceToView(self.img1, 10)
            .topEqualToView(self.img1)
            .widthIs(112)
            .heightIs(75);
            
            self.line
            .sd_layout
            .leftSpaceToView(self.contentView, 17)
            .rightSpaceToView(self.contentView, 17)
            .heightIs(1)
            .topSpaceToView(self.img0, 10);
            
    
            
            self.contentLab1.text = model.content;
            [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
            self.nameLab.text = model.companyName;
            
            NSString *urlimg0 = [array firstObject];
            NSString *urlimg1 = [array objectAtIndex:1];
            NSString *urlimg2 = [array objectAtIndex:2];
            [self.img0 sd_setImageWithURL:[NSURL URLWithString:urlimg0]];
            [self.img1 sd_setImageWithURL:[NSURL URLWithString:urlimg1]];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:urlimg2]];
            
           [self setupAutoHeightWithBottomView:self.line bottomMargin:0.01];
            [self updateLayout];
        }
    }
    if (model.type==1) {
        [self.img0 setHidden:YES];
        [self.img1 setHidden:YES];
        [self.img2 setHidden:YES];
        [self.contentLab1 setHidden:NO];
        [self.bigimg setHidden:NO];
        [self.rightimg setHidden:YES];
        [self.contentLab0 setHidden:YES];
        [self.iconImg setHidden:NO];
        [self.guanzhuBtn setHidden:YES];
        [self.renzhenImg setHidden:YES];
        
        self.iconImg
        .sd_layout
        .leftSpaceToView(self.contentView, 20)
        .topSpaceToView(self.contentView, 20)
        .widthIs(36)
        .heightIs(36);
        
        
        self.nameLab
        .sd_layout
        .leftSpaceToView(self.iconImg, 11)
        .heightIs(20)
        .topSpaceToView(self.contentView, 20);
        
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:(140)];
        
        if (model.recommendVip==1) {
            
            self.vipImg0
            .sd_layout
            .leftSpaceToView(self.nameLab, 15)
            .centerYEqualToView(self.nameLab)
            .widthIs(15)
            .heightIs(15);
            
            self.vipImg1
            .sd_layout
            .leftSpaceToView(self.nameLab, 35)
            .centerYEqualToView(self.nameLab)
            .widthIs(15)
            .heightIs(15);
            
            [self.vipImg0 setHidden:NO];
            [self.vipImg1 setHidden:NO];
        }
        else
        {
            [self.vipImg0 setHidden:YES];
            [self.vipImg1 setHidden:NO];
            
            self.vipImg1
            .sd_layout
            .leftSpaceToView(self.nameLab, 15)
            .centerYEqualToView(self.nameLab)
            .widthIs(15)
            .heightIs(15);
            
        }
        
        
        
        self.timeLab
        .sd_layout
        .leftEqualToView(self.nameLab)
        .topSpaceToView(self.nameLab, 7)
        .autoHeightRatio(0)
        .rightSpaceToView(self.contentView, 20);
        
        self.contentLab1
        .sd_layout
        .leftSpaceToView(self.contentView, 14)
        .rightSpaceToView(self.contentView, 14)
        .topSpaceToView(self.iconImg, 20)
        .autoHeightRatio(0);
        
        self.bigimg
        .sd_layout
        .leftEqualToView(self.contentLab1)
        .rightEqualToView(self.contentLab1)
        .topSpaceToView(self.contentLab1, 11)
        .heightIs(158);
        
        [self.contentLab1 setMaxNumberOfLinesToShow:2];
        
        self.contentLab1.text = model.content;
        
        NSArray *array = [model.picture1 componentsSeparatedByString:@","];
        NSString *imgurl = [array firstObject];
        [self.bigimg sd_setImageWithURL:[NSURL URLWithString:imgurl]];
        
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.companyLogo]];
        
        
        if (model.companyName.length>8) {
            NSString *subString1 = [model.companyName substringToIndex:7];
            NSString *subString2 = @"...";
            NSString *str = [subString1 stringByAppendingString:subString2];
            
            self.nameLab.text = str;
        }
        else
        {
            self.nameLab.text = model.companyName;
        }
        self.line
        .sd_layout
        .leftSpaceToView(self.contentView, 17)
        .rightSpaceToView(self.contentView, 17)
        .heightIs(1)
        .topSpaceToView(self.bigimg, 10);
        

        
        [self setupAutoHeightWithBottomView:self.line bottomMargin:0.01];
        [self updateLayout];
    }
}

#pragma mark - 实现方法

-(void)btn0click
{
    
}

-(void)btn1click
{
    
}

-(void)btn2click
{
    
}

-(void)btn3click
{
    
}

@end
