//
//  VIPExperienceView0.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "VIPExperienceView0.h"

@interface VIPExperienceView0()
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UIImageView *topImg;
@property (nonatomic,strong) UIButton *cloneBtn;
@property (nonatomic,strong) UILabel *contentlab0;
@property (nonatomic,strong) UILabel *contentlab1;


@end

@implementation VIPExperienceView0

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.topImg];
        [self.alertView addSubview:self.cloneBtn];
        [self.alertView addSubview:self.contentlab0];
        [self.alertView addSubview:self.contentlab1];
        [self.alertView addSubview:self.leftBtn];
        [self.alertView addSubview:self.rightBtn];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(267);
        make.height.mas_offset(247);
        make.top.equalTo(weakSelf).with.offset(128);
    }];
    
    [weakSelf.topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(267);
        make.height.mas_offset(109);
        make.top.equalTo(weakSelf).with.offset(128);
    }];
    
    [weakSelf.cloneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(17);
        make.height.mas_offset(17);
        make.top.equalTo(weakSelf.topImg).with.offset(8);
        make.right.equalTo(weakSelf.topImg).with.offset(-8);
    }];
    
    [weakSelf.contentlab0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(80);
        make.top.equalTo(weakSelf.topImg.mas_bottom).with.offset(27);
        
    }];
    
    [weakSelf.contentlab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.width.mas_offset(170);
        make.top.equalTo(weakSelf.contentlab0.mas_bottom).with.offset(11);
    }];
    
    [weakSelf.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(110);
        make.height.mas_offset(32);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/2-10);
        make.top.equalTo(weakSelf.contentlab1.mas_bottom).with.offset(20);
    }];
    
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(110);
        make.height.mas_offset(32);
        make.left.equalTo(weakSelf).with.offset(kSCREEN_WIDTH/2+10);
        make.top.equalTo(weakSelf.leftBtn);
    }];
}

#pragma mark - getters

-(UIView *)alertView
{
    if(!_alertView)
    {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 5;
    }
    return _alertView;
}


-(UIImageView *)topImg
{
    if(!_topImg)
    {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [UIImage imageNamed:@"bg_zhucechengg"];
    }
    return _topImg;
}

-(UIButton *)cloneBtn
{
    if(!_cloneBtn)
    {
        _cloneBtn = [[UIButton alloc] init];
        [_cloneBtn setImage:[UIImage imageNamed:@"guanbiges"] forState:normal];
        [_cloneBtn addTarget:self action:@selector(clonebtnclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cloneBtn;
}

-(UILabel *)contentlab0
{
    if(!_contentlab0)
    {
        _contentlab0 = [[UILabel alloc] init];
        _contentlab0.font = [UIFont systemFontOfSize:17];
        _contentlab0.textColor = Black_Color;
        _contentlab0.text = @"企业认证";
        _contentlab0.textAlignment = NSTextAlignmentCenter;
    }
    return _contentlab0;
}

-(UILabel *)contentlab1
{
    if(!_contentlab1)
    {
        _contentlab1 = [[UILabel alloc] init];
        _contentlab1.textAlignment = NSTextAlignmentCenter;
        _contentlab1.text = @"认证后能提升企业公信力";
        _contentlab1.font = [UIFont systemFontOfSize:14];
        _contentlab1.textColor = Black_Color;
    }
    return _contentlab1;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
       
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_leftBtn setTitleColor:[UIColor hexStringToColor:@"999999"] forState:normal];
        [_leftBtn setTitle:@"跳过" forState:normal];
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 16;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.borderColor = [UIColor hexStringToColor:@"999999"].CGColor;
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_rightBtn setTitleColor:[UIColor hexStringToColor:@"FFFFFF"] forState:normal];
        _rightBtn.backgroundColor = [UIColor hexStringToColor:@"2990EF"];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 16;
        [_rightBtn setTitle:@"认证" forState:normal];
    }
    return _rightBtn;
}

- (void)showView {
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dismissAlertView {
    [UIView animateWithDuration:.2 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08
                         animations:^{
                             self.alertView.transform = CGAffineTransformMakeScale(0.25, 0.25);
                         }completion:^(BOOL finish){
                             [self removeFromSuperview];
                         }];
    }];
}



#pragma mark - 实现方法


-(void)clonebtnclick
{
    [self dismissAlertView];
}

@end
