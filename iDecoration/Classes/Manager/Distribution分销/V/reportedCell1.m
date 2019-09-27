//
//  reportedCell1.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "reportedCell1.h"

@interface reportedCell1()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *leftlab;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UIImageView *youimg;

@end


@implementation reportedCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.lab1];
        [self.contentView addSubview:self.youimg];
        [self.contentView addSubview:self.timeLab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(20);
        make.width.mas_offset(60);
    }];
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftlab.mas_right).with.offset(14);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(20);
        make.width.mas_offset(80);
    }];
    [weakSelf.youimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab1.mas_right).with.offset(4);
        make.centerY.equalTo(weakSelf);
        make.height.mas_offset(17);
        make.width.mas_offset(9);
    }];
    [weakSelf.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.youimg.mas_right).with.offset(10);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(20);
    }];
}

#pragma  mark - getters

-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.text = @"开通时间";
        _leftlab.font = [UIFont systemFontOfSize:13];
        _leftlab.textColor = [UIColor hexStringToColor:@"676767"];
    }
    return _leftlab;
}


-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.text = @"请选择时间";
        _lab1.textColor = [UIColor hexStringToColor:@"9b9c9d"];
        _lab1.font = [UIFont systemFontOfSize:13];
    }
    return _lab1;
}

-(UIImageView *)youimg
{
    if(!_youimg)
    {
        _youimg = [[UIImageView alloc] init];
        _youimg.image = [UIImage imageNamed:@"向右"];
    }
    return _youimg;
}

-(UILabel *)timeLab
{
    if(!_timeLab)
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = [UIColor hexStringToColor:@"676767"];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.text = @"2018:12:20";
    }
    return _timeLab;
}

@end
