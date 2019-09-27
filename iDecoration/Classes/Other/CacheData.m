//
//  CacheData.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CacheData.h"

@implementation CacheData
+ (instancetype)sharedInstance {
    static CacheData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CacheData new];
    });
    return instance;
}
@end
