//
//  ActivityChangeMainTitleController.h
//  iDecoration
//
//  Created by sty on 2017/10/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ActivityChangeMainTitleController : SNViewController
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) void (^strBlock)(NSString *str);

@property (nonatomic, assign) NSInteger tag;//0:默认是修改主标题。1:普通的textview
@end
