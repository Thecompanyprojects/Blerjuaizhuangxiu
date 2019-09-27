//
//  GetShopTypeApi.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetShopTypeApi.h"

@implementation GetShopTypeApi

-(NSString*)requestUrl{
    
    return GetShopTypeUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}


@end
