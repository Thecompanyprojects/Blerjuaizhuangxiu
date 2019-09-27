//
//  SelectGoodsController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface SelectGoodsController : SNViewController
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, copy) void(^CompletionBlock)(NSArray *array);

@property (nonatomic, copy) void(^CompletionBlockWithGoodsModel)(NSArray *array);

@end
