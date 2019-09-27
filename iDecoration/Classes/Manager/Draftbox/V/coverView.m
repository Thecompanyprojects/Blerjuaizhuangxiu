//
//  coverView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "coverView.h"

@interface coverView()
@property (nonatomic,strong) UILabel *topLab;
@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;

@end

@implementation coverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLab];
        [self addSubview:self.leftLab];
        [self addSubview:self.rightLab];
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [self layout];
        
    }
    return self;
}

-(void)layout
{
    __weak typeof (self) weakSelf = self;

    [weakSelf.leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).with.offset(-20);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/2);
        make.height.mas_offset(20);
    }];
    [weakSelf.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.leftLab);
        make.right.equalTo(weakSelf);
        make.left.equalTo(weakSelf).with.offset(kSCREEN_WIDTH/2);
        make.height.mas_offset(20);
    }];
  
    [weakSelf.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(39);
        make.height.mas_offset(47);
        make.bottom.equalTo(weakSelf.leftLab.mas_top).with.offset(-14);
        make.left.equalTo(weakSelf).with.offset(kSCREEN_WIDTH/4-39/2);
    }];
    [weakSelf.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(49);
        make.height.mas_offset(47);
        make.bottom.equalTo(weakSelf.leftLab.mas_top).with.offset(-14);
        make.right.equalTo(weakSelf).with.offset(-kSCREEN_WIDTH/4+49/2);
    }];

    [weakSelf.topLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(18);
        make.height.mas_offset(22);
        make.centerX.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.leftBtn.mas_top).with.offset(-20);
    }];

}

#pragma mark - getters


-(UILabel *)topLab
{
    if(!_topLab)
    {
        _topLab = [[UILabel alloc] init];
        _topLab.text = @"推送到...";
        _topLab.font = [UIFont systemFontOfSize:18];
        _topLab.textColor = [UIColor hexStringToColor:@"7b7a7a"];
        
    }
    return _topLab;
}

-(UILabel *)leftLab
{
    if(!_leftLab)
    {
        _leftLab = [[UILabel alloc] init];
        _leftLab.textAlignment = NSTextAlignmentCenter;
        _leftLab.font = [UIFont systemFontOfSize:17];
        _leftLab.textColor = [UIColor blackColor];
        _leftLab.text = @"个人美文";
    }
    return _leftLab;
}

-(UILabel *)rightLab
{
    if(!_rightLab)
    {
        _rightLab = [[UILabel alloc] init];
        _rightLab.textAlignment = NSTextAlignmentCenter;
        _rightLab.font = [UIFont systemFontOfSize:17];
        _rightLab.text = @"新闻资讯";
    }
    return _rightLab;
}

-(UIButton *)leftBtn
{
    if(!_leftBtn)
    {
        _leftBtn = [[UIButton alloc] init];
        [_leftBtn setImage:[UIImage imageNamed:@"wode_caogao"] forState:normal];
    }
    return _leftBtn;
}

-(UIButton *)rightBtn
{
    if(!_rightBtn)
    {
        _rightBtn = [[UIButton alloc] init];
        [_rightBtn setImage:[UIImage imageNamed:@"xinwen_caogao"] forState:normal];
    }
    return _rightBtn;
}

@end
