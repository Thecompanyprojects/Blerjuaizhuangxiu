//
//  localgoodstypeHeaderView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localgoodstypeHeaderView.h"

@implementation localgoodstypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.typeLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).with.offset(10);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:10];
        _typeLab.textColor = [UIColor hexStringToColor:@"333333"];
    }
    return _typeLab;
}



@end
