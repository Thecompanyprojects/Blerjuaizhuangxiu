//
//  RegisterApi.m
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "RegisterApi.h"

@implementation RegisterApi
{
    NSString *_wxCode;
    NSString *_phone;
    NSNumber *_roleTypeId;
    NSNumber *_gender;
    NSString *_password;
    NSString *_trueName;
    NSString *_inviteCode;
    NSString *_phoneCode;
}

-(id)initWithWxCode:(NSString *)wxCode phone:(NSString *)phone roleTypeId:(NSInteger)roleTypeId gender:(NSInteger)gender password:(NSString *)password trueName:(NSString *)trueName inviteCode:(NSString *)inviteCode andphoneCode:(NSString *)phoneCode{
    
    if (self = [super init]) {
        
        _wxCode = wxCode;
        _phone = phone;
//        _roleTypeId = [NSNumber numberWithInteger:roleTypeId];
        _gender =  [NSNumber numberWithInteger:gender];
        _password = password;
        _trueName = trueName;
        _inviteCode = inviteCode;
        _phoneCode = phoneCode;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return RegisterUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"wxCode": _wxCode,
             @"phone": _phone,
             @"password": _password,
             @"trueName": _trueName,
             @"roleTypeId": @(0),
             @"gender": _gender,
             @"phoneCode":_phoneCode
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}
@end
