//
//  AdvertisementWebViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/11/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "AdvertisementWebViewController.h"

@interface AdvertisementWebViewController ()<WKUIDelegate, WKNavigationDelegate, UINavigationControllerDelegate>

@end

@implementation AdvertisementWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.delegate = self;
    self.title = @"广告图";
    [self setUpUI];
//    [self setUpBackButton];
}

- (void)setUpUI {
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, BLEJWidth, BLEJHeight - 64 )];
    //    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    //    webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    //    webView.UIDelegate = self;
    //    webView.navigationDelegate = self;
    self.webView = webView;
    [self.view addSubview:webView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame),1)];
//    [self.view addSubview:_progressView];
    _progressView.progressTintColor = kMainThemeColor;
    _progressView.trackTintColor = White_Color;
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)setUpBackButton {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 40, 40, 40);
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"mapBack"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"mapBack"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


- (void)dealloc {
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
@end
