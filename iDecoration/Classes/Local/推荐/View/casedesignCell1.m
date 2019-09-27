//
//  casedesignCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "casedesignCell1.h"
#import "newdesignModel.h"
#import <UIButton+LXMImagePosition.h>

@interface casedesignCell1()
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *designImg;
@property (nonatomic,strong) UIImageView *img0;
@property (nonatomic,strong) UIImageView *img1;
@property (nonatomic,strong) UIImageView *img2;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UIButton *readBtn;
@end

@implementation casedesignCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.designImg];
        [self.contentView addSubview:self.img0];
        [self.contentView addSubview:self.img1];
        [self.contentView addSubview:self.img2];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.readBtn];
    }
    return self;
}

-(void)setdata:(newdesignModel *)model
{
    __weak typeof (self) weakSelf = self;
    weakSelf.contentLab.text = model.designTitle;
    weakSelf.timeLab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:[NSString stringWithFormat:@"%ld",(long)model.addTime]];
    [weakSelf.readBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.readNum] forState:normal];
    if (model.imgUrl.count<3) {
        [self.img0 setHidden:YES];
        [self.img1 setHidden:YES];
        [self.img2 setHidden:YES];
        [self.designImg setHidden:NO];
        
        if (model.imgUrl.count==0) {
            [weakSelf.designImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
        }
        else
        {
            NSString *imgstr = [model.imgUrl firstObject];
            [weakSelf.designImg sd_setImageWithURL:[NSURL URLWithString:imgstr]];
        }
       
        weakSelf.designImg
        .sd_layout
        .widthIs(112)
        .heightIs(75)
        .topSpaceToView(weakSelf.contentView, 12)
        .rightSpaceToView(weakSelf.contentView, 15);
        
        weakSelf.contentLab
        .sd_layout
        .topEqualToView(weakSelf.designImg)
        .leftSpaceToView(weakSelf.contentView, 14)
        .rightSpaceToView(weakSelf.designImg, 8)
        .autoHeightRatio(0);
        [_contentLab setMaxNumberOfLinesToShow:2];
       
        weakSelf.timeLab
        .sd_layout
        .leftEqualToView(weakSelf.contentLab)
        .bottomEqualToView(weakSelf.designImg)
        .heightIs(13)
        .widthIs(80);
        
        weakSelf.readBtn
        .sd_layout
        .topEqualToView(weakSelf.timeLab)
        .leftSpaceToView(weakSelf.timeLab, 4)
        .widthIs(80)
        .heightIs(14);
        
        [weakSelf setupAutoHeightWithBottomView:weakSelf.designImg bottomMargin:10];
    }
    if (model.imgUrl.count>=3)
    {
        [self.img0 setHidden:NO];
        [self.img1 setHidden:NO];
        [self.img2 setHidden:NO];
        [self.designImg setHidden:YES];
       
        weakSelf.contentLab
        .sd_layout
        .leftSpaceToView(weakSelf.contentView, 12)
        .rightSpaceToView(weakSelf.contentView, 12)
        .topSpaceToView(weakSelf.contentView, 12)
        .autoHeightRatio(0);
        [_contentLab setMaxNumberOfLinesToShow:2];
        weakSelf.img1
        .sd_layout
        .widthIs(112)
        .heightIs(75)
        .centerXEqualToView(weakSelf)
        .topSpaceToView(weakSelf.contentLab, 10);
        
        weakSelf.img0
        .sd_layout
        .widthIs(112)
        .heightIs(75)
        .topEqualToView(weakSelf.img1)
        .rightSpaceToView(weakSelf.img1, 10);
        
        weakSelf.img2
        .sd_layout
        .leftSpaceToView(weakSelf.img1, 10)
        .topEqualToView(weakSelf.img1)
        .widthIs(112)
        .heightIs(75);
        
        weakSelf.timeLab
        .sd_layout
        .leftEqualToView(weakSelf.img0)
        .topSpaceToView(weakSelf.img0, 6)
        .widthIs(80)
        .heightIs(13);
        
        weakSelf.readBtn
        .sd_layout
        .leftSpaceToView(weakSelf.timeLab, 6)
        .topEqualToView(weakSelf.timeLab)
        .widthIs(80)
        .heightIs(13);
        
        NSString *imgstr0 = [model.imgUrl firstObject];
        NSString *imgstr1 = [model.imgUrl objectAtIndex:1];
        NSString *imgstr2 = [model.imgUrl objectAtIndex:2];
        
        [weakSelf.img0 sd_setImageWithURL:[NSURL URLWithString:imgstr0]];
        [weakSelf.img1 sd_setImageWithURL:[NSURL URLWithString:imgstr1]];
        [weakSelf.img2 sd_setImageWithURL:[NSURL URLWithString:imgstr2]];

        [weakSelf setupAutoHeightWithBottomView:weakSelf.timeLab bottomMargin:10];
    }
}

#pragma mark - getters

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor hexStringToColor:@"343434"];
        _contentLab.isAttributedContent = YES;
        
    }
    return _contentLab;
}

-(UIImageView *)designImg
{
    if(!_designImg)
    {
        _designImg = [[UIImageView alloc] init];
        _designImg.contentMode = UIViewContentModeScaleAspectFill;
        _designImg.layer.masksToBounds = YES;
    }
    return _designImg;
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
    return _img1
    ;
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
