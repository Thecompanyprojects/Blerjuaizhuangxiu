//
//  distributionCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/10.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "distributionCell.h"

@interface distributionCell()
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *lab;
@end

@implementation distributionCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img];
        [self addSubview:self.lab];
        [self setuplauout];
    }
    return self;
}


-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(18*widthScale);
        make.width.mas_offset(29*widthScale);
        make.height.mas_offset(29*widthScale);
    }];
    [weakSelf.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(4);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.img.mas_bottom).with.offset(12);
    }];
}

#pragma mark - getters

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
    }
    return _img;
}

-(UILabel *)lab
{
    if(!_lab)
    {
        _lab = [[UILabel alloc] init];
        _lab.textColor = [UIColor hexStringToColor:@"000000"];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.text = @"123";
    }
    return _lab;
}

-(void)setdata:(NSString *)imgstr andtext:(NSString *)textstr
{
    self.img.image = [UIImage imageNamed:imgstr];
    self.lab.text = textstr;;
}

@end
