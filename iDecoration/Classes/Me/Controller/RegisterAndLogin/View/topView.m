//
//  topView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "topView.h"

@interface topView()
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UILabel *contentlab;
@property (nonatomic,strong) UILabel *textLab;
@end

@implementation topView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img];
        [self addSubview:self.contentlab];
        [self addSubview:self.textLab];
        [self addSubview:self.hidBtn];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(50);
        make.width.mas_offset(82);
        make.height.mas_offset(82);
    }];
    [weakSelf.contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(14);
        make.top.equalTo(weakSelf.img.mas_bottom).with.offset(20);
        make.height.mas_offset(25);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(20);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.contentlab.mas_bottom).with.offset(20);
    }];
    [weakSelf.hidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(50);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.textLab.mas_bottom).with.offset(20);
        make.height.mas_offset(36);
    }];
}

#pragma mark - getters

-(UIImageView *)img
{
    if(!_img)
    {
        _img = [[UIImageView alloc] init];
        _img.image = [UIImage imageNamed:@"bangding"];
    }
    return _img;
}


-(UILabel *)contentlab
{
    if(!_contentlab)
    {
        _contentlab = [[UILabel alloc] init];
        _contentlab.textAlignment = NSTextAlignmentCenter;
        _contentlab.font = [UIFont systemFontOfSize:20];
        _contentlab.text = @"你还没绑定手机号哦";
        _contentlab.textColor = [UIColor hexStringToColor:@"2F2E2E"];
    }
    return _contentlab;
}

-(UILabel *)textLab
{
    if(!_textLab)
    {
        _textLab = [[UILabel alloc] init];
        _textLab.font = [UIFont systemFontOfSize:15];
        _textLab.text = @"     根据国家互联网信息办公室发 布的《移动互联网应用程序信息服务 管理规定》，自2016年8月20日起， 注册用户需基于移动号码等真实身份信息进行认证";
        _textLab.numberOfLines = 0;
        _textLab.textColor = [UIColor hexStringToColor:@"999999"];
    }
    return _textLab;
}


-(UIButton *)hidBtn
{
    if(!_hidBtn)
    {
        _hidBtn = [[UIButton alloc] init];
        _hidBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [_hidBtn setTitle:@"我知道了" forState:normal];
        [_hidBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _hidBtn.backgroundColor = Main_Color;
        
    }
    return _hidBtn;
}





@end
