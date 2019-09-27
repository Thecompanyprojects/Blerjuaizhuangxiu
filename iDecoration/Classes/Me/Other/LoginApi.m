//
//  LoginApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "LoginApi.h"

@implementation LoginApi
{
    NSString *_phone;
    NSString *_flag;
    NSString *_password;
}

-(id)initWithPhone:(NSString *)phone flag:(NSString *)flag password:(NSString *)password{
    
    if (self = [super init]) {
        
        _phone = phone;
        _flag = flag;
        _password = password;
    }
    
    return self;
}

-(NSString*)requestUrl{
    
    return LoginUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phone,
             @"flag": _flag,
             @"password": _password
             };
}


- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}


@end
