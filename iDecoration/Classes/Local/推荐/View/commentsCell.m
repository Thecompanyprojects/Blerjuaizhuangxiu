//
//  commentsCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "commentsCell.h"
#import <SDAutoLayout.h>
#import "commentsModel.h"

@interface commentsCell()
@property (nonatomic,strong) UIImageView *icomImg;
@property (nonatomic,strong) UILabel *namelab;
@property (nonatomic,strong) UILabel *timelab;
@property (nonatomic,strong) UILabel *contentlab;
@end

@implementation commentsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
//        self.contentView.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:self.icomImg];
        [self.contentView addSubview:self.namelab];
        [self.contentView addSubview:self.timelab];
        [self.contentView addSubview:self.contentlab];
        [self setuplauout];
    }
    return self;
}

-(void)setdata:(commentsModel *)model
{
    //[self.icomImg sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    [self.icomImg sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"defaultman"]];
    self.namelab.text = model.trueName;
    self.timelab.text = [[PublicTool defaultTool] getDateFormatStrFromTimeStamp:model.crateTime];
    self.contentlab.text = model.content;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    
    weakSelf.icomImg
    .sd_layout
    .leftSpaceToView(weakSelf.contentView, 20)
    .topSpaceToView(weakSelf.contentView, 20)
    .widthIs(36)
    .heightIs(36);
    
    weakSelf.namelab
    .sd_layout
    .leftSpaceToView(weakSelf.icomImg, 12)
    .topEqualToView(weakSelf.icomImg)
    .rightSpaceToView(weakSelf.contentView, 20)
    .heightIs(20);
    
    weakSelf.timelab
    .sd_layout
    .leftEqualToView(weakSelf.namelab)
    .rightEqualToView(weakSelf.namelab)
    .topSpaceToView(weakSelf.namelab, 6)
    .heightIs(16);
    
    weakSelf.contentlab
    .sd_layout
    .leftEqualToView(weakSelf.namelab)
    .rightSpaceToView(weakSelf.contentView, 14)
    .topSpaceToView(weakSelf.timelab, 20)
    .autoHeightRatio(0);
    
    [weakSelf setupAutoHeightWithBottomView:weakSelf.contentlab bottomMargin:14];
    
}

#pragma mark - getters


-(UIImageView *)icomImg
{
    if(!_icomImg)
    {
        _icomImg = [[UIImageView alloc] init];
        _icomImg.layer.masksToBounds = YES;
        _icomImg.layer.cornerRadius = 18;
    }
    return _icomImg;
}


-(UILabel *)namelab
{
    if(!_namelab)
    {
        _namelab = [[UILabel alloc] init];
        _namelab.font = [UIFont systemFontOfSize:14];
        _namelab.textColor = [UIColor darkGrayColor];
    }
    return _namelab;
}


-(UILabel *)timelab
{
    if(!_timelab)
    {
        _timelab = [[UILabel alloc] init];
        _timelab.font = [UIFont systemFontOfSize:12];
        _timelab.textColor = [UIColor hexStringToColor:@"5D5E5F"];
    }
    return _timelab;
}

-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.font = [UIFont systemFontOfSize:14];
        _contentlab.textColor = [UIColor darkGrayColor];
    }
    return _contentlab;
}





@end
