//
//  ActivityChangeAssistantTitleController.h
//  iDecoration
//
//  Created by sty on 2017/10/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ActivityChangeAssistantTitleController : SNViewController
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) void (^strBlock)(NSString *str);
@end
