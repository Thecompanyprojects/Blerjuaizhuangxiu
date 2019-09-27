//
//  BLEJCalculatorGetCompanyList.m
//  Calculator
//
//  Created by 赵春浩 on 17/5/2.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJCalculatorGetCompanyList.h"

@implementation BLEJCalculatorGetCompanyList {
    
    NSString *_companyName;
}

- (id)initWithCompanyName:(NSString *)companyName {
    
    if (self = [super init]) {
        
        _companyName = companyName;
    }
    return self;
}

- (NSString *)requestUrl {
    
    return BLEJCalculatorGetCompanyListUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    return @{
             @"companyName": _companyName,
             };
}




@end
