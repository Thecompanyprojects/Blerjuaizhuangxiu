//
//  spreadmenuCell.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "spreadmenuCell.h"


@implementation spreadmenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.typeLab];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UILabel *)typeLab
{
    if(!_typeLab)
    {
        _typeLab = [[UILabel alloc] init];
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.textColor = Black_Color;
        _typeLab.font = [UIFont systemFontOfSize:14];
    }
    return _typeLab;
}


@end
