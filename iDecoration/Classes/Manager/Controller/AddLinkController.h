//
//  AddLinkController.h
//  iDecoration
//
//  Created by sty on 2017/9/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface AddLinkController : SNViewController
@property (nonatomic, copy) NSString *linkAddress;
@property (nonatomic, copy) NSString *linkDescrib;
@property (nonatomic, copy) NSString *myContructLink;//我的工地链接

@property (nonatomic, assign) NSInteger consID;

@property (nonatomic, copy) void (^addLinkBlock) (NSString *linkUrl, NSString *linkDescrib);
@end
