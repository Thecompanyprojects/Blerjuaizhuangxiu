//
//  NewConstructionApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "NewConstructionApi.h"

@implementation NewConstructionApi
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
    
    return NewConstructionUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"agencysId": [NSNumber numberWithInteger:_agencysId]
             };
}

@end
