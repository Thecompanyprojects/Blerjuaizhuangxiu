//
//  AdvertisementWebViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/11/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import <WebKit/WebKit.h>

@interface AdvertisementWebViewController : SNViewController
// 进度条
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKWebView *webView;
@property (copy, nonatomic) NSString *webUrl;
- (void)setUpUI;
@end
