//
//  rankingView.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "rankingView.h"

@interface rankingView()

@end

@implementation rankingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.rankingView0];
        [self addSubview:self.rankingView1];
        [self addSubview:self.rankingView2];
        [self setuplayout];
        
    }
    return self;
}


-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf.rankingView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf).with.offset(10);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(30);
    }];
    
    [weakSelf.rankingView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf.rankingView0.mas_bottom).with.offset(10);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(30);
    }];
    
    [weakSelf.rankingView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf);
        make.top.equalTo(weakSelf.rankingView1.mas_bottom).with.offset(10);
        make.right.equalTo(weakSelf);
        make.height.mas_offset(30);
    }];
    
}

#pragma mark - getters


-(recommendrankingView *)rankingView0
{
    if(!_rankingView0)
    {
        _rankingView0 = [[recommendrankingView alloc] init];
        _rankingView0.userInteractionEnabled = YES;
    }
    return _rankingView0;
}


-(recommendrankingView *)rankingView1
{
    if(!_rankingView1)
    {
        _rankingView1 = [[recommendrankingView alloc] init];
        _rankingView1.userInteractionEnabled = YES;
    }
    return _rankingView1;
}

-(recommendrankingView *)rankingView2
{
    if(!_rankingView2)
    {
        _rankingView2 = [[recommendrankingView alloc] init];
        _rankingView2.userInteractionEnabled = YES;
    }
    return _rankingView2;
}



@end
