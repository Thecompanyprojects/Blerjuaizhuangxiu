//
//  ModifyPwdApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ModifyPwdApi.h"

@implementation ModifyPwdApi
{
    NSString *_phone;
    NSString *_oldPwd;
    NSString *_newPwd;
}

-(id)initWithPhone:(NSString *)phone oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd{
    
    if (self = [super init]) {
        
        _phone = phone;
        _oldPwd = oldPwd;
        _newPwd = newPwd;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return ModifyPwdUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phone,
             @"oldPwd": _oldPwd,
             @"newPwd": _newPwd
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
