//
//  GetCityListApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetCityListApi.h"

@implementation GetCityListApi
{
    NSString *_pid;
}

-(id)initWithPid:(NSString *)pid{
    
    if (self = [super init]) {
        
        _pid = pid;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetCityListUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"pid": _pid
             };
}

@end
