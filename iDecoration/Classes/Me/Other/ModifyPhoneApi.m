//
//  ModifyPhoneApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ModifyPhoneApi.h"

@implementation ModifyPhoneApi
{
    NSString *_phone;
    NSInteger _agencyId;
    NSInteger _code;
}

-(id)initWithPhone:(NSString *)phone agencyId:(NSInteger)agencyId code:(NSInteger)code{
    
    if (self = [super init]) {
        
        _phone = phone;
        _agencyId = agencyId;
        _code = code;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return ModifyPhoneUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phone,
             @"agencyId": [NSNumber numberWithInteger:_agencyId],
             @"code": [NSNumber numberWithInteger:_code]
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
