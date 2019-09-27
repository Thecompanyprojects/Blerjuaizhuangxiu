//
//  GetDiaryApi.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetDiaryApi.h"

@implementation GetDiaryApi
{
    NSInteger _constructionId;
    NSInteger _agencysId;
}

-(id)initWithConstructionId:(NSInteger)constructionId agencysId:(NSInteger)agencysId{
    
    if (self = [super init]) {
        _constructionId = constructionId;
        _agencysId = agencysId;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetDiaryUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"constructionId": [NSNumber numberWithInteger:_constructionId],
             @"agencysId": [NSNumber numberWithInteger:_agencysId]
             };
}


@end
