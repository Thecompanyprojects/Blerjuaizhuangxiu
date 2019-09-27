//
//  WorkTypeModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTypeModel : NSObject
@property (strong, nonatomic) NSString *jobId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *children;
@property (strong, nonatomic) NSArray *list;
@property (assign, nonatomic) BOOL isSelected;

@end
