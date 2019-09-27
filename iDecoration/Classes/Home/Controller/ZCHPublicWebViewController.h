//
//  ZCHPublicWebViewController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ZCHPublicWebViewController : SNViewController
@property (assign, nonatomic) BOOL isNeedShareButton;
@property (copy, nonatomic) NSString *titleStr;
@property (copy, nonatomic) NSString *webUrl;
@property (strong, nonatomic) NSMutableDictionary *parameters;
@property (nonatomic, assign) BOOL isAddBaseUrl; //no默认：需要添加baseUrl yes：不需要添加，直接加载
@end
