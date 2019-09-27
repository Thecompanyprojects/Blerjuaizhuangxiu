//
//  SenceQRShareView.m
//  iDecoration
//
//  Created by zuxi li on 2017/9/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SenceQRShareView.h"

@interface SenceQRShareView()
//@property (nonatomic, strong) UILabel *goodsNameLabel;
//@property (nonatomic, strong) UIImageView * goodsCoverImageView;
//@property (nonatomic, strong) UIImageView * QRCodeImageView;

@property (nonatomic, strong) UILabel *topLabel1;
@property (nonatomic, strong) UILabel *topLabel2;
//@property (nonatomic, strong) UIImageView *topImageView;


@property (nonatomic, strong) UIImageView *topCornerImageView;
@property (nonatomic, strong) UIImageView *bottomCornerImageView;

@property (nonatomic, strong) UILabel *middleLabel1;
@property (nonatomic, strong) UILabel *middleLabel2;


@end

@implementation SenceQRShareView


- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self topLabel1];
        [self topLabel2];
        [self topImageView];
        [self bgView];
        [self topCornerImageView];
        [self goodsNameLabel];
        [self goodsCoverImageView];
        [self bottomCornerImageView];
        [self middleLabel1];
        [self middleLabel2];
        [self QRCodeImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addBorderToLayer:self.bgView];
}

- (UILabel *)topLabel1 {
    if (_topLabel1 == nil) {
        _topLabel1 = [UILabel new];
        [self addSubview:_topLabel1];
        [_topLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kSize(40));
            make.centerX.equalTo(0);
        }];
        _topLabel1.text = @"这里有诗和远方 还有你的家！";
        _topLabel1.textColor = [UIColor colorWithRed:68/225.0 green:159/255.0 blue:227/255.0 alpha:1.0];
        _topLabel1.font = [UIFont systemFontOfSize:kSize(20)];

        _topLabel1.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel1;
}

- (UILabel *)topLabel2 {
    if (_topLabel2 == nil) {
        _topLabel2 = [UILabel new];
        [self addSubview:_topLabel2];
        CGFloat topMargin = IPhone5 ? 10 : 20;
        [_topLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLabel1.mas_bottom).equalTo(topMargin);
            make.centerX.equalTo(0);
        }];
        _topLabel2.text = @"漫游从指间开始，扫描二维码，尽情体验......";
        _topLabel2.font = [UIFont systemFontOfSize:kSize(17)];
        _topLabel2.textColor = [UIColor lightGrayColor];
        _topLabel2.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabel2;
}

- (UIImageView *)topImageView {
    if (_topImageView == nil) {
        _topImageView = [UIImageView new];
        [self addSubview:_topImageView];
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.size.equalTo(CGSizeMake(50, 30));
            make.top.equalTo(self.topLabel2.mas_bottom).equalTo(8);
        }];
        _topImageView.image = [UIImage imageNamed:@"share_jiantou"];
    }
    return _topImageView;
}


- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [UIView new];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImageView.mas_bottom).equalTo(8);
            make.bottom.equalTo(-kSize(30));
            make.left.equalTo(kSize(30));
            make.right.equalTo(-kSize(30));
        }];
    }
    return _bgView;
}

- (UIImageView *)topCornerImageView {
    if (!_topCornerImageView) {
        _topCornerImageView = [[UIImageView alloc] init];
        [self.bgView addSubview:_topCornerImageView];
        [_topCornerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kSize(10));
            make.right.equalTo(-10);
            make.size.equalTo(CGSizeMake(kSize(65), kSize(45)));
        }];
        _topCornerImageView.image = [UIImage imageNamed:@"shareCorner_top"];
    }
    return _topCornerImageView;
}

- (UILabel *)goodsNameLabel {
    if (_goodsNameLabel == nil) {
        _goodsNameLabel = [[UILabel alloc] init];
        [self.bgView addSubview:_goodsNameLabel];
        [_goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topCornerImageView.mas_bottom).equalTo(-kSize(20));
            make.right.equalTo(-15);
            make.left.equalTo(15);
        }];
        _goodsNameLabel.numberOfLines = 2;
        _goodsNameLabel.font = [UIFont systemFontOfSize:kSize(20)];
        _goodsNameLabel.textColor = [UIColor lightGrayColor];
        _goodsNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _goodsNameLabel;
}

- (UIImageView *)goodsCoverImageView {
    if (_goodsCoverImageView == nil) {
        _goodsCoverImageView = [UIImageView new];
        [self.bgView addSubview:_goodsCoverImageView];
        [_goodsCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsNameLabel.mas_bottom).equalTo(kSize(8));
            make.centerX.equalTo(0);
            make.size.equalTo(CGSizeMake(kSCREEN_WIDTH/ 2.0, kSCREEN_WIDTH/3.0));
        }];
    }
    return _goodsCoverImageView;
}

- (UIImageView *)bottomCornerImageView {
    if (_bottomCornerImageView == nil) {
        _bottomCornerImageView = [UIImageView new];
        [self.bgView addSubview:_bottomCornerImageView];
        [_bottomCornerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.goodsCoverImageView.mas_bottom).equalTo(-kSize(20));
            make.left.equalTo(20);
            make.size.equalTo(CGSizeMake(kSize(65), kSize(45)));
        }];
        _bottomCornerImageView.image = [UIImage imageNamed:@"shareCorner_left"];
    }
    return _bottomCornerImageView;
}

- (UILabel *)middleLabel1 {
    if (_middleLabel1 == nil) {
        _middleLabel1 = [UILabel new];
        __block CGFloat topMargin = IPhone5 ? 10 : 20;
        [self.bgView addSubview:_middleLabel1];
        [_middleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.bottomCornerImageView.mas_bottom).equalTo(topMargin);
        }];
        _middleLabel1.text = @"扫描二维码";
        _middleLabel1.font = [UIFont systemFontOfSize:kSize(19)];
        _middleLabel1.textColor = [UIColor lightGrayColor];
    }
    return _middleLabel1;
}

- (UILabel *)middleLabel2 {
    if (_middleLabel2 == nil) {
        _middleLabel2 = [UILabel new];
        [self.bgView addSubview:_middleLabel2];
        [_middleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.middleLabel1.mas_bottom).equalTo(4);
        }];
        _middleLabel2.text = @"开始畅游未来家!";
        _middleLabel2.font = [UIFont systemFontOfSize:kSize(19)];
        _middleLabel2.textColor = [UIColor lightGrayColor];
    }
    return _middleLabel2;
}

- (UIImageView *)QRCodeImageView {
    if (_QRCodeImageView == nil) {
        _QRCodeImageView = [[UIImageView alloc] init];
        [self.bgView addSubview:_QRCodeImageView];
        [_QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(self.middleLabel2.mas_bottom).equalTo(10);
            make.size.equalTo(CGSizeMake(kSize(160), kSize(160)));
        }];
    }
    return _QRCodeImageView;
}

- (void)addBorderToLayer:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor colorWithRed:68/225.0 green:159/255.0 blue:227/255.0 alpha:1.0].CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
    border.lineWidth = 1;
    
    border.lineCap = @"square";
    //  第一个是 线条长度   第二个是间距    nil时为实线
    border.lineDashPattern = @[@9, @4];
    [view.layer addSublayer:border];
}


@end
