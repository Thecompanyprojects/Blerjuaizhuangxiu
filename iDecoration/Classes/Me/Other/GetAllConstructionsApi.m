//
//  GetAllConstructionsApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetAllConstructionsApi.h"

@implementation GetAllConstructionsApi
{
    NSString *_ccAreaName;
    NSInteger _agencyId;
    NSInteger _pageNo;
    NSInteger _pageSize;
}

-(id)initWithCcAreaName:(NSString *)ccAreaName agencyId:(NSInteger)agencyId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize{
    
    if (self = [super init]) {
        _ccAreaName = ccAreaName;
        _agencyId = agencyId;
        _pageNo = pageNo;
        _pageSize = pageSize;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetAllMyConstructionUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

-(id)requestArgument{
    
    return @{
             @"ccAreaName":_ccAreaName,
             @"agencyId":[NSNumber numberWithInteger:_agencyId],
             @"pageNo":[NSNumber numberWithInteger:_pageNo],
             @"pageSize":[NSNumber numberWithInteger:_pageSize]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
