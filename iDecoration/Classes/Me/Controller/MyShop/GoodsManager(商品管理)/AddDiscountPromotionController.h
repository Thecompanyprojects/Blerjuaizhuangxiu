//
//  AddDiscountPromotionController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface AddDiscountPromotionController : SNViewController
@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, copy) void(^CompletionBlock)();
@end
