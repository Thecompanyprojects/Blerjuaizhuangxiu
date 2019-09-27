//
//  FeedBackApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "FeedBackApi.h"

@implementation FeedBackApi
{
    NSString *_phone;
    NSString *_content;
    NSString *_trueName;
    NSString *_source;
}


-(id)initWithPhone:(NSString *)phone content:(NSString *)content trueName:(NSString *)trueName{
    
    if (self = [super init]) {
        
        _phone = phone;
        _content = content;
        _trueName = trueName;
    }
    return self;
}

- (id)initWithPhone:(NSString *)phone content:(NSString *)content trueName:(NSString *)trueName source:(NSString *)source {
    if (self = [super init]) {
        _phone = phone;
        _content = content;
        _trueName = trueName;
        _source = source;
    }
    return self;
}
-(NSString*)requestUrl{
    
    return FeedBackUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"phone": _phone,
             @"content": _content,
             @"trueName": _trueName,
             @"source": _source
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}


@end
