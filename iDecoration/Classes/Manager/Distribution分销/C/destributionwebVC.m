//
//  destributionwebVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "destributionwebVC.h"
#import <WebKit/WebKit.h>

@interface destributionwebVC ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) WKWebView *web;
@end

@implementation destributionwebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleStr;
    
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlstr]]];
    [self.view addSubview:self.web];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters


-(WKWebView *)web
{
    if(!_web)
    {
        _web = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _web.UIDelegate = self;
        _web.navigationDelegate = self;
    }
    return _web;
}





@end
