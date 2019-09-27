//
//  VerifyIdentifyCodeApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "VerifyIdentifyCodeApi.h"

@implementation VerifyIdentifyCodeApi
{
    NSString *_phoneNumber;
    NSString *_code;
}

-(id)initWithPhoneNumber:(NSString *)phone code:(NSString *)code{
    
    if (self = [super init]) {
        
        _phoneNumber = phone;
        _code = code;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return VerifyIdentifyCodeUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phoneNumber,
             @"code": _code
             };
}


- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
