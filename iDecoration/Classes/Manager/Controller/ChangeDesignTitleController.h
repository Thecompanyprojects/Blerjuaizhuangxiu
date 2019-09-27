//
//  ChangeDesignTitleController.h
//  iDecoration
//
//  Created by sty on 2017/8/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ChangeDesignTitleController : SNViewController
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) void (^strBlock)(NSString *str);
@end
