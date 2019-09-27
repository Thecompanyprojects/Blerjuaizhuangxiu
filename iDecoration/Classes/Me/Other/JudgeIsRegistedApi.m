//
//  JudgeIsRegistedApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "JudgeIsRegistedApi.h"

@implementation JudgeIsRegistedApi
{
    NSString *_phoneNumber;
}


-(id)initWithPhoneNumber:(NSString *)phone{
    
    if (self = [super init]) {
        
        _phoneNumber = phone;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return IsRegistedUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phoneNumber
             };
}


- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
