//
//  CaseMaterialController.h
//  iDecoration
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CaseMaterialController : UIViewController
@property (nonatomic, assign) NSInteger cJobTypeId;
@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) NSInteger fromIndex; // 1:从施工日志进入 2:从主材日志进入
@end
