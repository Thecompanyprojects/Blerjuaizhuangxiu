//
//  ActivitySignUpSettingController.h
//  iDecoration
//
//  Created by sty on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ActivitySignUpSettingController : SNViewController
@property (nonatomic, copy) void(^SignUpBlock)(NSMutableArray *array);
@property (nonatomic, strong) NSMutableArray *setDataArray;
@end
