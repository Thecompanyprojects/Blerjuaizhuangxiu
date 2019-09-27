//
//  GetSiteADImgApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "GetSiteADImgApi.h"

@implementation GetSiteADImgApi
{
    NSInteger _cityNumber;
}


- (id)initWithCityNumber:(NSInteger)cityNumber {
    
    if (self = [super init]) {
        
        _cityNumber = cityNumber;
    }
    return self;
}


-(NSString*)requestUrl{
    
    return GetSiteImageListUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{@"cityNumber": [NSNumber numberWithInteger:_cityNumber]};
}

@end
