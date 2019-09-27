//
//  FinishSiteApi.m
//  iDecoration
//
//  Created by RealSeven on 2017/3/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "FinishSiteApi.h"

@implementation FinishSiteApi
{
    NSString *_constructionId;
}

-(id)initWithConstructionId:(NSString *)constructionId{
    
    if (self = [super init]) {
        _constructionId = constructionId;
    }
    return self;
}

-(NSString*)requestUrl{
    return ConfirmCompleteUrl;
}
-(YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}
-(id)requestArgument{
    
    return @{@"constructionId":_constructionId};
}


- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
