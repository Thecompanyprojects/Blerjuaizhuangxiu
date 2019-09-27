//
//  localbannerView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localbannerView.h"

@interface localbannerView()

@property (nonatomic,strong) NSMutableArray *masonryViewArray;
@end

@implementation localbannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn0];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self addSubview:self.btn3];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    
    // 实现masonry水平固定间隔方法
    
    self.masonryViewArray = [NSMutableArray array];
    [self.masonryViewArray addObject:self.btn0];
    [self.masonryViewArray addObject:self.btn1];
    [self.masonryViewArray addObject:self.btn2];
    [self.masonryViewArray addObject:self.btn3];
    
    __weak typeof (self) weakSelf = self;
//    [weakSelf.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:(kSCREEN_WIDTH-2)/4 leadSpacing:0.1 tailSpacing:0.1];
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(kSCREEN_WIDTH-2)/4 leadSpacing:0.5 tailSpacing:0.5];
    
    // 设置array的垂直方向的约束
    [weakSelf.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - getters

-(UIButton *)btn0
{
    if(!_btn0)
    {
        _btn0 = [[UIButton alloc] init];
        _btn0.backgroundColor = White_Color;
        [_btn0 setTitle:@"电话咨询" forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:11];
        [_btn0 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        [_btn0 setImage:[UIImage imageNamed:@"bottomPhone"] forState:normal];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        _btn1.backgroundColor = White_Color;
        [_btn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        [_btn1 setTitle:@"赠送礼物" forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:11];
        [_btn1 setImage:[UIImage imageNamed:@"icon_liwu"] forState:normal];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        _btn2.backgroundColor = [UIColor hexStringToColor:@"FD6766"];
        [_btn2 setTitle:@"免费报价" forState:normal];
        [_btn2 setTitleColor:White_Color forState:normal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _btn2;
}

-(UIButton *)btn3
{
    if(!_btn3)
    {
        _btn3 = [[UIButton alloc] init];
        _btn3.backgroundColor = [UIColor hexStringToColor:@"22AA3B"];
        [_btn3 setTitle:@"免费预约" forState:normal];
        [_btn3 setTitleColor:White_Color forState:normal];
        _btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _btn3;
}





@end
