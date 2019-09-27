//
//  VIPExperienceView2.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/31.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "VIPExperienceView2.h"

@interface VIPExperienceView2()
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UILabel *contentLab;


@end

@implementation VIPExperienceView2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.alertView];
        [self.alertView addSubview:self.topLab];
        [self.alertView addSubview:self.contentLab];
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
        make.height.mas_offset(160);
        make.top.equalTo(weakSelf).with.offset(128);
    }];
    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.alertView).with.offset(20);
        make.top.equalTo(weakSelf.alertView).with.offset(26);
        make.centerX.equalTo(weakSelf);
    }];
    [weakSelf.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.topLab);
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.topLab.mas_bottom).with.offset(20);
    }];
    [weakSelf.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(104);
        make.height.mas_offset(32);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/2-10);
        make.top.equalTo(weakSelf.contentLab.mas_bottom).with.offset(29);
    }];
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(104);
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
        _alertView.backgroundColor = White_Color;
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 6;
    }
    return _alertView;
}

-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.textAlignment = NSTextAlignmentCenter;
        _topLab.text = @"开通会员";
        _topLab.textColor = Black_Color;
        _topLab.font = [UIFont systemFontOfSize:17];
        
    }
    return _topLab;
}

-(UILabel *)contentLab
{
    if(!_contentLab)
    {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textAlignment = NSTextAlignmentCenter;
        _contentLab.text = @"开通爱装修会员可使用更多功能";
        _contentLab.textColor = Black_Color;
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    return _contentLab;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
       
        [_leftBtn setTitle:@"跳过" forState:normal];
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = 14;
        _leftBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_leftBtn setTitleColor:[UIColor lightGrayColor] forState:normal];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setTitle:@"查看会员特权" forState:normal];
        _rightBtn.layer.masksToBounds = YES;
        _rightBtn.layer.cornerRadius = 14;
        _rightBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _rightBtn.layer.borderWidth = 1;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:normal];
        _rightBtn.backgroundColor = [UIColor hexStringToColor:@"2990ef"];
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

@end
