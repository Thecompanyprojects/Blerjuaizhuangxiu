//
//  BatchManagerViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface BatchManagerViewController : SNViewController

@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger agencyJob;
@property (nonatomic, copy) void(^CompletionBlock)();
@end
