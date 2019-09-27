//
//  changeuserinfoCell2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "changeuserinfoCell2.h"

@interface changeuserinfoCell2()
@property (nonatomic,strong) UIImageView *xinxin;
@property (nonatomic,strong) UILabel *leftlab;
@property (nonatomic,strong) UIImageView *rightimg;
@end

@implementation changeuserinfoCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self.contentView addSubview:self.xinxin];
        [self.contentView addSubview:self.leftlab];
        [self.contentView addSubview:self.rightimg];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.xinxin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(14);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
    }];
    [weakSelf.leftlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.xinxin.mas_right).with.offset(10);
        make.height.mas_offset(20);
    }];
    [weakSelf.rightimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.leftlab.mas_right).with.offset(10);
        make.centerY.equalTo(weakSelf);
        make.width.mas_offset(9);
        make.height.mas_offset(17);
    }];
}

#pragma mark - getters

-(UIImageView *)xinxin
{
    if(!_xinxin)
    {
        _xinxin = [[UIImageView alloc] init];
        _xinxin.image = [UIImage imageNamed:@"xinxin0"];
    }
    return _xinxin;
}

-(UILabel *)leftlab
{
    if(!_leftlab)
    {
        _leftlab = [[UILabel alloc] init];
        _leftlab.font = [UIFont systemFontOfSize:15];
        _leftlab.text = @"绑定你账户";
        _leftlab.textColor = [UIColor hexStringToColor:@"292929"];
    }
    return _leftlab;
}


-(UIImageView *)rightimg
{
    if(!_rightimg)
    {
        _rightimg = [[UIImageView alloc] init];
        _rightimg.image = [UIImage imageNamed:@"向右"];
    }
    return _rightimg;
}



@end
