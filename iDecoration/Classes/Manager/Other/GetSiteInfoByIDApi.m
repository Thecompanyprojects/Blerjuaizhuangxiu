//
//  GetSiteInfoByIDApi.m
//  iDecoration
//
//  Created by RealSeven on 2017/3/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetSiteInfoByIDApi.h"

@implementation GetSiteInfoByIDApi
{
    NSInteger _constructionID;
}
-(id)initWithConstructionID:(NSInteger)constructionID{
    
    if (self = [super init]) {
        _constructionID = constructionID;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetSiteInfoByIDUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"id":[NSNumber numberWithInteger:_constructionID]
             };
}
@end
