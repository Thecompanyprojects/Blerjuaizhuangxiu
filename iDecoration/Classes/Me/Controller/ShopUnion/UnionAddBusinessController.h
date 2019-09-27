//
//  UnionAddBusinessController.h
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface UnionAddBusinessController : SNViewController
@property (nonatomic, copy) void(^UnionAddBusBlock)();
@property (nonatomic, assign) NSInteger unionId;
@property (nonatomic, copy) NSString *unionName;
@end
