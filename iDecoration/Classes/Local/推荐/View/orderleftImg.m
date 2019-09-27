//
//  orderleftImg.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "orderleftImg.h"

@interface orderleftImg()

@end

@implementation orderleftImg

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgimg];
        [self addSubview:self.numberlab];
        [self setuplauout];
    }
    return self;
}

-(void)setuplauout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.bgimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
    }];
    [weakSelf.numberlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIImageView *)bgimg
{
    if(!_bgimg)
    {
        _bgimg = [[UIImageView alloc] init];
        
    }
    return _bgimg;
}

-(UILabel *)numberlab
{
    if(!_numberlab)
    {
        _numberlab = [[UILabel alloc] init];
        _numberlab.font = [UIFont systemFontOfSize:10];
        _numberlab.textColor = [UIColor whiteColor];
        _numberlab.textAlignment = NSTextAlignmentCenter;
    }
    return _numberlab;
}




@end
