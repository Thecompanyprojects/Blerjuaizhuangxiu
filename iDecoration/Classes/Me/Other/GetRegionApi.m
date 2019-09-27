//
//  GetRegionApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetRegionApi.h"

@implementation GetRegionApi

-(NSString*)requestUrl{
    
    return GetRegionUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

-(id)requestArgument{
    
    return @{};
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
