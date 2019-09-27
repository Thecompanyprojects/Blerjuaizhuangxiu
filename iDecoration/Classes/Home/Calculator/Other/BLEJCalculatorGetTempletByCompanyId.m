//
//  BLEJCalculatorGetTempletByCompanyId.m
//  Calculator
//
//  Created by 赵春浩 on 17/5/2.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "BLEJCalculatorGetTempletByCompanyId.h"

@implementation BLEJCalculatorGetTempletByCompanyId {
    
    NSString *_companyId;
}

- (id)initWithCompanyId:(NSString *)companyId {
    
    if (self = [super init]) {
        
        _companyId = companyId;
    }
    return self;
}

- (NSString *)requestUrl {
    
    return BLEJCalculatorGetTempletByCompanyIdUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    return @{
             @"companyId": _companyId,
             };
}

@end
