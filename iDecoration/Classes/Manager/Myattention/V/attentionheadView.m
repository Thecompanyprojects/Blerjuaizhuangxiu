//
//  attentionheadView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "attentionheadView.h"

@interface attentionheadView()
@property (nonatomic,strong) UIView *line;

@end


@implementation attentionheadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.line];
        [self addSubview:self.titleLab];
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
       // make.top.equalTo(weakSelf).with.offset(3);
        make.width.mas_offset(2);
        make.height.mas_offset(18);
        make.left.equalTo(weakSelf).with.offset(14);
    }];
    [weakSelf.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.line.mas_right).with.offset(4);
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).with.offset(-14);
        make.height.mas_offset(20);
    }];
}

#pragma mark - getters

-(UIView *)line
{
    if(!_line)
    {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor hexStringToColor:@"25D764"];
        
    }
    return _line;
}

-(UILabel *)titleLab
{
    if(!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor hexStringToColor:@"999999"];
        _titleLab.font = [UIFont systemFontOfSize:12];
    }
    return _titleLab;
}


@end
