//
//  YellowActicleView.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YellowActicleView : UIView

@property (nonatomic, assign) NSInteger designsId;
@property (nonatomic, strong) UIWebView *webView;

- (void)setDesignsId:(NSInteger)designsId andCompanyId:(NSInteger)companyID;

@end
