//
//  wallentinstructionsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "wallentinstructionsVC.h"
#import <WebKit/WebKit.h>

@interface wallentinstructionsVC ()<WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end



@implementation wallentinstructionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"说明";
    
    NSString *urlstr =  [BASEHTML stringByAppendingString:@"resources/html/wodeqianbao.html"];
    _webView = [[WKWebView alloc] init];
    CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
    _webView.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, kSCREEN_WIDTH, naviBottom);
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
