//
//  CompanyLogoApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CompanyLogoApi.h"

@implementation CompanyLogoApi
{
    UIImage *_file;
}

-(id)initWithFile:(UIImage*)file{
    
    if (self = [super init]) {
        
        _file = file;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return CompanyLogoUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"file":_file
             };
}

@end
