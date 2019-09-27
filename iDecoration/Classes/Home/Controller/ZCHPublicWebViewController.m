//
//  ZCHPublicWebViewController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHPublicWebViewController.h"
#import <WebKit/WebKit.h>
#import "ZYCShareView.h"

@interface ZCHPublicWebViewController ()<WKUIDelegate, WKNavigationDelegate>
// 进度条
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) ZYCShareView *shareView;
@property (copy, nonatomic) NSString *shareURL;
@end

@implementation ZCHPublicWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = self.titleStr;
    [self setUpUI];
}

- (void)setUpUI {
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, BLEJWidth, BLEJHeight - self.navigationController.navigationBar.bottom)];
    if (!self.isAddBaseUrl) {
        self.shareURL = [BASEHTML stringByAppendingString:self.webUrl];
    }else{
        self.shareURL = self.webUrl;
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.shareURL]]];
    [self.view addSubview:_webView];
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom, CGRectGetWidth(self.view.frame),1)];
    [self.view addSubview:_progressView];
    _progressView.progressTintColor = kMainThemeColor;
    _progressView.trackTintColor = White_Color;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    if (self.isNeedShareButton) {
        [self setupRightButton];
        self.shareView = [ZYCShareView sharedInstance];
        [self makeShareView];
    }
}

- (void)setupRightButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton setTitle:@"分享" forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFixedSpace) target:nil action:nil];
    item.width = -7;
    self.navigationItem.rightBarButtonItems = @[item,rightItem];
    [rightButton addTarget:self  action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f) {
            
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)didTouchRightButton {
    [self.shareView share];

}

- (void)makeShareView {
    self.shareView.URL = self.shareURL;
    self.shareView.shareTitle = self.titleStr;
    self.shareView.shareCompanyIntroduction = self.titleStr;
    self.shareView.shareCompanyLogo = @"shareDefaultIcon";
    self.shareView.companyName = self.titleStr;
    self.shareView.shareViewType = ZYCShareViewTypeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
