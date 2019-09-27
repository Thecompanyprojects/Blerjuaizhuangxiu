//
//  GetShopInfoByIDApi.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetShopInfoByIDApi.h"

@implementation GetShopInfoByIDApi
{
    NSString *_merchantId;
}

-(id)initWithMerchantId:(NSString*)merchantId{
    
    if (self = [super init]) {
        _merchantId = merchantId;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetShopInfoByIDUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{@"merchantId":_merchantId};
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}


@end
