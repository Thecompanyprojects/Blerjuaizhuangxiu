//
//  activityzoneHeaderView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "activityzoneHeaderView.h"


@interface activityzoneHeaderView()<SDCycleScrollViewDelegate>


@end

@implementation activityzoneHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
        [self addSubview:self.btn0];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.lab0];
        [self addSubview:self.lab1];
        [self addSubview:self.lab2];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.height.mas_offset(193);
    }];
    [weakSelf.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(24);
        make.top.equalTo(weakSelf.scrollView.mas_bottom).with.offset(14);
        make.height.mas_offset(25);
    }];
    [weakSelf.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(24);
        make.top.equalTo(weakSelf.btn1);
        make.left.equalTo(weakSelf).with.offset(54);
        make.height.mas_offset(25);
    }];
    [weakSelf.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(24);
        make.top.equalTo(weakSelf.btn1);
        make.right.equalTo(weakSelf).with.offset(-54);
        make.height.mas_offset(25);
    }];
    [weakSelf.lab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.btn0);
        make.top.equalTo(weakSelf.btn0.mas_bottom).with.offset(10);
        make.height.mas_offset(15);
    }];
    [weakSelf.lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.btn1);
        make.top.equalTo(weakSelf.lab0);
        make.height.mas_offset(15);
    }];
    [weakSelf.lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.btn2);
        make.top.equalTo(weakSelf.lab0);
        make.height.mas_offset(15);
    }];
}

#pragma mark - getters

-(SDCycleScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [[SDCycleScrollView alloc] init];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        [_btn0 setImage:[UIImage imageNamed:@"icon_fujin"] forState:normal];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setImage:[UIImage imageNamed:@"icon_shijian"] forState:normal];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setImage:[UIImage imageNamed:@"icon_guanzhu"] forState:normal];
    }
    return _btn2;
}

-(UILabel *)lab0
{
    if(!_lab0)
    {
        _lab0 = [[UILabel alloc] init];
        _lab0.textAlignment = NSTextAlignmentCenter;
        _lab0.font = [UIFont systemFontOfSize:12];
        _lab0.textColor = [UIColor hexStringToColor:@"676767"];
        _lab0.text = @"附近";
        _lab0.userInteractionEnabled = YES;
    }
    return _lab0;
}
-(UILabel *)lab1
{
    if(!_lab1)
    {
        _lab1 = [[UILabel alloc] init];
        _lab1.textAlignment = NSTextAlignmentCenter;
        _lab1.font = [UIFont systemFontOfSize:12];
        _lab1.textColor = [UIColor hexStringToColor:@"676767"];
        _lab1.text = @"时间";
        _lab1.userInteractionEnabled = YES;

    }
    return _lab1;
}

-(UILabel *)lab2
{
    if(!_lab2)
    {
        _lab2 = [[UILabel alloc] init];
        _lab2.textAlignment = NSTextAlignmentCenter;
        _lab2.font = [UIFont systemFontOfSize:12];
        _lab2.textColor = [UIColor hexStringToColor:@"676767"];
        _lab2.text = @"关注";
        _lab2.userInteractionEnabled = YES;

    }
    return _lab2;
}

-(void)labelTouchUpInside0
{
    
}

-(void)labelTouchUpInside1
{
    
}

-(void)labelTouchUpInside2
{
    
}

@end
