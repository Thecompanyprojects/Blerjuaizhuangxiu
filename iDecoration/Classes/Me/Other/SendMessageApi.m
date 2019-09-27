//
//  SendMessageApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SendMessageApi.h"

@implementation SendMessageApi
{
    NSString *_phoneNumber;
    NSString *_smsType;
}


-(id)initWithPhoneNumber:(NSString *)phone smsType:(NSString *)smsType{
    
    if (self = [super init]) {
        _phoneNumber = phone;
        _smsType = smsType;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return GetIdentifyCodeUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
        @"phone": _phoneNumber,
        @"smsType": _smsType
    };
}


- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}
@end
