//
//  GetCompanyListApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetCompanyListApi.h"

@implementation GetCompanyListApi
{
    NSInteger _agencysId;
}

-(id)initWithAgencysId:(NSInteger)agencysId{
    
    if (self = [super init]) {
        _agencysId = agencysId;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetCompanyListUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"agencysId": [NSNumber numberWithInteger:_agencysId]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
