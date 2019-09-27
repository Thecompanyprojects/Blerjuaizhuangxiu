//
//  promoteView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "promoteView.h"

@interface promoteView()
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UILabel *lab2;
@property (nonatomic,strong) UIView *line0;
@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIImageView *img;

@end

@implementation promoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor hexStringToColor:@"FC716F"];
        [self addSubview:self.lab0];
        [self addSubview:self.lab1];
        [self addSubview:self.lab2];
        [self addSubview:self.line0];
        [self addSubview:self.line1];
        [self addSubview:self.codeimg];
        [self addSubview:self.img];
        [self addSubview:self.contentlab];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(15);
        make.right.equalTo(weakSelf).with.offset(-15);
        make.top.equalTo(weakSelf).with.offset(16);
    }];
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab0);
        make.right.equalTo(weakSelf.lab0);
        make.top.equalTo(weakSelf.lab0.mas_bottom).with.offset(10);
    }];
    [weakSelf.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.lab1.mas_bottom).with.offset(10);
        make.width.mas_offset(60);
    }];
    [weakSelf.line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab0);
        make.top.equalTo(weakSelf.lab2).with.offset(8);
        make.right.equalTo(weakSelf.lab2.mas_left).with.offset(5);
        make.height.mas_offset(2);
    }];
    [weakSelf.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lab2.mas_right).with.offset(5);
        make.top.equalTo(weakSelf.lab2).with.offset(8);
        make.right.equalTo(weakSelf.lab0);
        make.height.mas_offset(2);
    }];
  
    [weakSelf.codeimg mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.left.equalTo(weakSelf).with.offset(32*widthScale);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.lab2.mas_bottom).with.offset(30);
        make.height.mas_offset(kSCREEN_WIDTH-34*WIDTH_SCALE-64*WIDTH_SCALE);
        make.width.mas_offset(kSCREEN_WIDTH-34*WIDTH_SCALE-64*WIDTH_SCALE);
    }];
    
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.lab2.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf).with.offset(40*widthScale);
        make.height.mas_offset(36);
    }];
    
    [weakSelf.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.codeimg);
        make.right.equalTo(weakSelf.codeimg);
        make.top.equalTo(weakSelf.codeimg.mas_bottom).with.offset(6);
        make.centerX.equalTo(weakSelf);
        make.height.mas_offset(30);
    }];
}

#pragma mark - getters

-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.text = @"全民下载";
        _lab0.textAlignment = NSTextAlignmentCenter;
        _lab0.font = [UIFont systemFontOfSize:45];
        _lab0.textColor = [UIColor whiteColor];

    }
    return _lab0;
}


-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textColor = [UIColor whiteColor];
        _lab1.font = [UIFont systemFontOfSize:25];
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.text = @"坐在家里也能赚钱";
    }
    return _lab1;
}


-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2.textColor = [UIColor whiteColor];
        _lab2.text = @"爱装修";
        _lab2.font = [UIFont systemFontOfSize:16];
        _lab2.textAlignment = NSTextAlignmentCenter;
    }
    return _lab2;
}

-(UIView *)line0
{
    if(!_line0)
    {
        _line0 = [[UIView alloc] init];
        _line0.backgroundColor = [UIColor whiteColor];
    }
    return _line0;
}

-(UIView *)line1
{
    if(!_line1)
    {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor whiteColor];
    }
    return _line1;
}


-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"tuiguang0"];
    }
    return _img;
}

-(UIImageView *)codeimg
{
    if(!_codeimg)
    {
        _codeimg = [[UIImageView alloc] init];

    }
    return _codeimg;
}


-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.textAlignment = NSTextAlignmentCenter;
        _contentlab.font = [UIFont systemFontOfSize:15];
        _contentlab.text = @"我的专属邀请码:d91028";
        _contentlab.textColor = [UIColor whiteColor];
        _contentlab.backgroundColor = [UIColor hexStringToColor:@"d15858"];
    }
    return _contentlab;
}









@end
