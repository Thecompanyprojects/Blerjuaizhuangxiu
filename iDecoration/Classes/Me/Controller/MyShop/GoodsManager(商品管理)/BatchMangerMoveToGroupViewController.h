//
//  BatchMangerMoveToGroupViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@class ClassifyModel;
@interface BatchMangerMoveToGroupViewController : SNViewController
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, strong) NSArray *deleteArray;

@property (nonatomic, copy)void(^CompleteBlock)();

// 编辑商品时的分组
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy)void(^EditingCompleteBlock)(ClassifyModel *classifyModel);
@end
