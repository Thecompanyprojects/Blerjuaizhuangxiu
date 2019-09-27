//
//  ResetPwdApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ResetPwdApi.h"

@implementation ResetPwdApi
{
    NSString *_phone;
    NSString *_code;
    NSString *_newPwd;
}

-(id)initWithPhoneNumber:(NSString *)phone code:(NSString *)code newPwd:(NSString *)newPwd{
    
    if (self = [super init]) {
        
        _phone = phone;
        _code = code;
        _newPwd = newPwd;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return ResetPasswordUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phone,
             @"code": _code,
             @"newPwd": _newPwd
             };
}


- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
