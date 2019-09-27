//
//  localofferHeader.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localofferHeader.h"

@interface localofferHeader()
@property (nonatomic,strong) NSMutableArray *masonryViewArray;
@end


@implementation localofferHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn0];
        [self addSubview:self.btn1];
        [self addSubview:self.btn2];
        [self setuplayout];
    }
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    self.masonryViewArray = [NSMutableArray array];
    [self.masonryViewArray addObject:self.btn0];
    [self.masonryViewArray addObject:self.btn1];
    [self.masonryViewArray addObject:self.btn2];
    
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
        [_btn0 setTitle:@"距离" forState:normal];
        [_btn0 setTitleColor:Main_Color forState:normal];
        _btn0.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn0 addTarget:self action:@selector(btn0click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn0;
}

-(UIButton *)btn1
{
    if(!_btn1)
    {
        _btn1 = [[UIButton alloc] init];
        [_btn1 setTitle:@"好评" forState:normal];
        [_btn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn1 addTarget:self action:@selector(btn1click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn1;
}

-(UIButton *)btn2
{
    if(!_btn2)
    {
        _btn2 = [[UIButton alloc] init];
        [_btn2 setTitle:@"信用" forState:normal];
        [_btn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
        _btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btn2 addTarget:self action:@selector(btn2click) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn2;
}

-(void)btn0click
{
    [self.btn0 setTitleColor:Main_Color forState:normal];
    [self.btn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [self.btn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
}

-(void)btn1click
{
    [self.btn1 setTitleColor:Main_Color forState:normal];
    [self.btn0 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [self.btn2 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
}

-(void)btn2click
{
    [self.btn2 setTitleColor:Main_Color forState:normal];
    [self.btn1 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
    [self.btn0 setTitleColor:[UIColor hexStringToColor:@"333333"] forState:normal];
}

@end
