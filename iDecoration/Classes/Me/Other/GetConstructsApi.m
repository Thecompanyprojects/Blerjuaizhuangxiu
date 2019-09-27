//
//  GetConstructsApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetConstructsApi.h"

@implementation GetConstructsApi
{
     NSInteger _userId;
}

-(id)initWithUserId:(NSInteger)userId{
    
    if (self = [super init]) {
        
        _userId = userId;
        
// 测试数据
//#ifdef TEST_DEFINE
//        _userId = 10381;
//#endif
        

    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetConstructsUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

-(id)requestArgument{
    
    return @{
             @"id": [NSNumber numberWithInteger:_userId]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
