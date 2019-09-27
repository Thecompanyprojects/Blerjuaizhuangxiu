//
//  ComplainListApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ComplainListApi.h"

@implementation ComplainListApi
{
    NSInteger _agencyId;
    NSInteger _pageNo;
    NSInteger _pageSize;
}
-(id)initWithAgencyId:(NSInteger)agencyId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize{
    
    if (self = [super init]) {
        _agencyId = agencyId;
        _pageNo = pageNo;
        _pageSize = pageSize;
    }
    return self;
}
-(NSString*)requestUrl{
    
    return ComplainListUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"agencyId": [NSNumber numberWithInteger:_agencyId],
             @"pageNo": [NSNumber numberWithInteger:_pageNo],
             @"pageSize": [NSNumber numberWithInteger:_pageSize]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
