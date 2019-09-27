//
//  BackGoodsListBottomView.m
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "BackGoodsListBottomView.h"

@interface BackGoodsListBottomView()
@property (nonatomic, strong) NSArray *buttonTitle;
@end

@implementation BackGoodsListBottomView

@synthesize titleArray = _titleArray;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}


- (void)setupUI {
    CGFloat buttonWidth = kSCREEN_WIDTH * 1.0/self.buttonTitle.count;
    for (int i = 0; i < self.buttonTitle.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, self.frame.size.height);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont systemFontOfSize:kSize(16)];
        [btn setTitle:self.buttonTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat lineMargin = (kSCREEN_WIDTH - self.buttonTitle.count + 1)/self.buttonTitle.count;
    
    for (int i = 0; i < self.buttonTitle.count - 1; i ++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineMargin * (i + 1), self.frame.size.height/4.0, 1, self.frame.size.height/2.0)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
}

- (NSArray *)buttonTitle {
    if (_buttonTitle == nil) {
        _buttonTitle = @[@"添加商品", @"商品推广", @"批量管理", @"分组管理"];
    }
    return _buttonTitle;
}

- (void)buttonAction:(UIButton *)sender {
    NSInteger index = sender.tag;
    if ([self.delegate respondsToSelector:@selector(bottomView:BtnClicked:)]) {
        [self.delegate bottomView:self BtnClicked:index];
    }
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    self.buttonTitle = titleArray;
    [self removeAllSubViews];
    [self setupUI];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = self.buttonTitle;
    }
    return _titleArray;
}
@end
