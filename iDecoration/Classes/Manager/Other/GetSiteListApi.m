//
//  GetSiteListApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetSiteListApi.h"

@implementation GetSiteListApi
{
    NSInteger _userId;
    NSString *_ccHouseholderName;
}

-(id)initWithUserId:(NSInteger)userId ccHouseholderName:(NSString *)ccHouseholderName{
    
    if (self = [super init]) {
        
        _userId = userId;
        _ccHouseholderName = ccHouseholderName;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetSiteListUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"id": [NSNumber numberWithInteger:_userId],
             @"ccHouseholderName": _ccHouseholderName
             };
}

@end
