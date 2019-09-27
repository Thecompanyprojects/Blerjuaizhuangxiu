//
//  GetUserInfoApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetUserInfoApi.h"

@implementation GetUserInfoApi
{
    NSInteger _agencyId;
}

-(id)initWithAgencyId:(NSInteger)agencyId{
    
    if (self = [super init]) {
        _agencyId = agencyId;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetUserInfoUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

-(id)requestArgument{
    
    return @{
             @"agencyId":[NSNumber numberWithInteger:_agencyId]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
