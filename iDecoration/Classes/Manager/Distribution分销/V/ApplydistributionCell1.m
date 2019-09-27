//
//  ApplydistributionCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "ApplydistributionCell1.h"

@interface ApplydistributionCell1()

@end

@implementation ApplydistributionCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.leftLab];
        [self.contentView addSubview:self.contentlab];
       
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(12);
        make.height.mas_offset(12);
    }];
    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.img.mas_right).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(80*WIDTH_SCALE);
        make.height.mas_offset(20);
    }];
    
    [weakSelf.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(80*WIDTH_SCALE);
        make.height.mas_offset(20);
        make.left.equalTo(weakSelf.leftLab.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-30);
    }];
}

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"xinxin0"];
    }
    return _img;
}

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.font = [UIFont systemFontOfSize:14];
        _leftLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _leftLab;
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
