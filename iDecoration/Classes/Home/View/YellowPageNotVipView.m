//
//  YellowPageNotVipView.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "YellowPageNotVipView.h"

@interface YellowPageNotVipView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation YellowPageNotVipView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViewWithFrame:frame];
    }
    return self;
}


- (void)buildViewWithFrame:(CGRect)frame {
    CGPoint point = frame.origin;
    CGSize size = frame.size;
    CGRect newFrame = CGRectMake(point.x, point.y, size.width, size.height - 44);
    _webView = [[UIWebView alloc] initWithFrame:newFrame];
    [self addSubview:_webView];
    _webView.scrollView.bounces = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;
    NSString *urlStr = [BASEHTML stringByAppendingString:@"resources/html/feihuiyuanhuangyejieshao.html"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    UIButton *expBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = kSCREEN_WIDTH *313.0/750.0;
    expBtn.frame = CGRectMake(0, size.height - 44, width, 44);
    [self addSubview:expBtn];
    [expBtn setBackgroundColor:kCustomColor(35, 38, 54) forState:UIControlStateNormal];
    [expBtn setTitle:@"非会员体验" forState:(UIControlStateNormal)];
    expBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [expBtn setTitleColor:kCustomColor(237, 200, 87) forState:(UIControlStateNormal)];
    [expBtn addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openVipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openVipBtn.frame = CGRectMake(width, size.height - 44, kSCREEN_WIDTH-width, 44);
    [self addSubview:openVipBtn];
    [openVipBtn setBackgroundColor:kCustomColor(237, 200, 87) forState:UIControlStateNormal];
    [openVipBtn setTitle:@"立即开通" forState:(UIControlStateNormal)];
    openVipBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [openVipBtn setTitleColor:kCustomColor(35, 38, 54) forState:(UIControlStateNormal)];
    [openVipBtn addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *image = [UIImage imageNamed:@"YellowPage_notVipPage"];
//    CGFloat height = image.size.height/image.size.width * kSCREEN_WIDTH;
//    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:frame];
//    [self addSubview:scrollview];
//    scrollview.contentSize = CGSizeMake(kSCREEN_WIDTH, height);
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
//    imageV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, height);
//    [scrollview addSubview:imageV];
//    scrollview.showsVerticalScrollIndicator = NO;
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scrollview addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(0);
//        if (IPhone6Plus) {
//            make.top.equalTo(472);
//            make.size.equalTo(CGSizeMake(287, 44));
//        }else if (IPhone5) {
//            make.top.equalTo(360);
//            make.size.equalTo(CGSizeMake(200, 40));
//        } else {
//            make.top.equalTo(428);
//            make.size.equalTo(CGSizeMake(227, 44));
//        }
//
//    }];
//    [btn addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scrollview addSubview:btn2];
//    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(0);
//        if (IPhone6Plus) {
//            make.top.equalTo(btn.mas_bottom).equalTo(22);
//            make.size.equalTo(CGSizeMake(287, 44));
//        }else if (IPhone5) {
//            make.top.equalTo(btn.mas_bottom).equalTo(16);
//            make.size.equalTo(CGSizeMake(200, 40));
//        } else {
//            make.top.equalTo(btn.mas_bottom).equalTo(22);
//            make.size.equalTo(CGSizeMake(227, 44));
//        }
//    }];
//    [btn2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scrollview addSubview:btn3];
//    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(imageV.mas_bottom).equalTo(0);
//        make.left.equalTo(0);
//        make.size.equalTo(CGSizeMake(kSCREEN_WIDTH * (157.0/375), 45));
//    }];
//    [btn3 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [scrollview addSubview:btn4];
//    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(imageV.mas_bottom).equalTo(0);
//        make.left.equalTo(btn3.mas_right);
//        make.size.equalTo(CGSizeMake(kSCREEN_WIDTH * (1 - 157.0/375), 45));
//    }];
//    [btn4 addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"openvip"]) {//开会员
        [self action1];
        return false;
    }
    if ([[url scheme] isEqualToString:@"expressvip"]) {//体验会员
        [self action2];
        return false;
    }
    return YES;
}


- (void)action1 {
    if (self.OpenVipBlock) {
        self.OpenVipBlock();
    }
}

- (void)action2 {
    if (self.ExperienceVipBlock) {
        self.ExperienceVipBlock();
    }
}
@end
