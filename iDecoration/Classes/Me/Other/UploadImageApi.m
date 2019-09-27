//
//  UploadImageApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UploadImageApi.h"

@implementation UploadImageApi
{
    NSString *_imgStr;//图片字符串base64
    NSString *_type;//格式（如：jpg，png）
}

-(id)initWithImgStr:(NSString*)imgStr type:(NSString*)type{
    
    if (self = [super init]) {
        _imgStr = imgStr;
        _type = type;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return UploadImageUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"imgStr": _imgStr,
             @"type": _type
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}


@end
