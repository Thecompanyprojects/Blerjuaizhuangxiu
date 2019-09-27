//
//  GetJobListApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetJobListApi.h"

@implementation GetJobListApi

-(NSString*)requestUrl{
    
    return GetJobListUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{};
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
