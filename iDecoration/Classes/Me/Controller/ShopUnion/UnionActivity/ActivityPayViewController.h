//
//  ActivityPayViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface ActivityPayViewController : SNViewController
@property (nonatomic, copy) NSString *activityID;
@property (nonatomic, assign) NSInteger signUpId; // 报名id
@property (copy, nonatomic) void(^successBlock)();

@end
