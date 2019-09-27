//
//  YellowActicleView.m
//  iDecoration
//
//  Created by zuxi li on 2018/5/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "YellowActicleView.h"

@interface YellowActicleView()<UIWebViewDelegate>

@end

@implementation YellowActicleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildViewWithFrame:frame];
    }
    return self;
}

- (void)setDesignsId:(NSInteger)designsId  {
    _designsId = designsId;
}

- (void)setDesignsId:(NSInteger)designsId andCompanyId:(NSInteger)companyID {
    self.designsId = designsId;
    NSString *url = [NSString stringWithFormat:@"%@designs/novip/%ld/%ld.htm",BASEURL,(long)designsId,(long)companyID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}



- (void)buildViewWithFrame:(CGRect)frame {
    
    _webView = [[UIWebView alloc] initWithFrame:frame];
    [self addSubview:_webView];
    _webView.scalesPageToFit = YES;
    _webView.translatesAutoresizingMaskIntoConstraints=YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
    _webView.scrollView.bounces = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    
//    NSString *url = [NSString stringWithFormat:@"%@designs/returnHtml.do?designsId=%ld&agencysId=0&type=%ld",BASEURL,(long)self.designsId,(long)4];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    [self.webView loadRequest:request];
}



@end
