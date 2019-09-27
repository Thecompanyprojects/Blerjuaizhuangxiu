//
//  VoteSetController.h
//  iDecoration
//
//  Created by sty on 2017/8/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface VoteSetController : SNViewController
@property (nonatomic, assign) BOOL isFistr;//是否是第一次添加
@property (nonatomic, copy) NSString *voteTheme;//投票描述
@property (nonatomic, strong) NSMutableArray *dateArray;//投票数组
@property (nonatomic, copy) NSString *timeStr;//截止时间

@property (nonatomic, copy) NSString *voteType;//投票类型

@property (nonatomic, copy)void(^voteBlock)(NSString *voteTheme,NSMutableArray *optionArray,NSString *endTime,NSInteger voteType);
@end
