//
//  ChangeDesignTitleTwoController.h
//  iDecoration
//  修改副标题
//  Created by sty on 2017/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ChangeDesignTitleTwoController : SNViewController
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) void (^strBlock)(NSString *str);
@end
