//
//  EditHanApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "EditHanApi.h"

@implementation EditHanApi
{
    NSInteger _orderId;
}

-(id)initWithOrderId:(NSInteger)orderId{
    
    if (self = [super init]) {
        _orderId = orderId;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return EditHanOrderUrl;
}
-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

-(id)requestArgument{
    
    return @{
             @"id": [NSNumber numberWithUnsignedInteger:_orderId]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
