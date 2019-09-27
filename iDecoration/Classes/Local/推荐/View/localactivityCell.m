//
//  localactivityCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localactivityCell.h"
#import <SDAutoLayout.h>
#import "localactivityModel.h"


@interface localactivityCell()
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *timeImg;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *typeLab;
@end

@implementation localactivityCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.topImg];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.timeImg];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.typeLab];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(localactivityModel *)model
{
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.coverMap]];
    self.contentLab.text = model.designTitle;
    NSString *str1 = [NSString stringWithFormat:@"%ld",model.startTime];
    NSString *str2 = [NSString stringWithFormat:@"%ld",model.endTime];
    NSString *starttime = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:str1];
    NSString *endtime = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:str2];
    self.timeLab.text = [NSString stringWithFormat:@"%@%@%@",starttime,@"~",endtime];
    
    if (model.activityStatus==0) {
        self.typeLab.text = @"报名中";
        self.typeLab.textColor = [UIColor hexStringToColor:@"FB9952"];
        self.typeLab.layer.masksToBounds = YES;
        self.typeLab.layer.cornerRadius = 2;
        self.typeLab.layer.borderWidth = 1;
        self.typeLab.layer.borderColor = [UIColor hexStringToColor:@"FB9952"].CGColor;
        self.typeLab.backgroundColor = [UIColor hexStringToColor:@"FDDBC4"];
    }
    else
    {
        self.typeLab.text = @"报名已满";
        self.typeLab.textColor = [UIColor hexStringToColor:@"FFFFFF"];
        self.typeLab.layer.masksToBounds = YES;
        self.typeLab.layer.cornerRadius = 2;
        self.typeLab.layer.borderWidth = 1;
        self.typeLab.layer.borderColor = [UIColor hexStringToColor:@"FFFFFF"].CGColor;
        self.typeLab.backgroundColor = [UIColor hexStringToColor:@"A5A5A5"];
    }
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    weakSelf.topImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .rightSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.contentView, 14)
    .heightIs(188);
    
    weakSelf.contentLab
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.topImg, 17)
    .autoHeightRatio(0)
    .rightSpaceToView(weakSelf.contentView, 14);
    
    [weakSelf.contentLab setMaxNumberOfLinesToShow:2];
    
    weakSelf.timeImg
    .sd_layout
    .leftEqualToView(weakSelf.contentLab)
    .topSpaceToView(weakSelf.contentLab, 14)
    .widthIs(16)
    .heightIs(16);
    
    weakSelf.timeLab
    .sd_layout
    .leftSpaceToView(weakSelf.timeImg, 15)
    .centerYEqualToView(weakSelf.timeImg)
    .heightIs(20);
    [weakSelf.timeLab setSingleLineAutoResizeWithMaxWidth:(240)];
    
    weakSelf.typeLab
    .sd_layout
    .rightSpaceToView(weakSelf.contentView, 14)
    .heightIs(20)
    .widthIs(60)
    .topEqualToView(weakSelf.timeLab);
    
    [weakSelf setupAutoHeightWithBottomView:_typeLab bottomMargin:14];
}

#pragma mark - getters


-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        
    }
    return _topImg;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = [UIFont systemFontOfSize:15];
    }
    return _contentLab;
}

-(UIImageView *)timeImg
{
    if(!_timeImg)
    {
        _timeImg = [[UIImageView alloc] init];
        _timeImg.image = [UIImage imageNamed:@"icon_time"];
    }
    return _timeImg;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:13];
        _timeLab.textColor = [UIColor hexStringToColor:@"A5A5A5"];
    }
    return _timeLab;
}

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:13];
        _typeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLab;
}

@end
