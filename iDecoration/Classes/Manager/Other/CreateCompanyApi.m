//
//  CreateCompanyApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CreateCompanyApi.h"

@implementation CreateCompanyApi
{
    CGFloat _createPerson;//创建人
    NSString *_companyLogo;//公司logo
    NSString *_companyName;//公司名称
    NSString *_companyNumber;//公司号，默认手机号,不可编辑
    NSString *_companySlogan;//标语
    CGFloat _agencysJob;//公司职位
    NSString *_areaList;//装修区域
    NSInteger _headQuarters;//是否为总公司(0：不是，1：是）
}

-(id)initWithCreatePerson:(CGFloat)createPerson companyLogo:(NSString*)companyLogo companyName:(NSString*)companyName companyNumber:(NSString *)companyNumber companySlogan:(NSString*)companySlogan areaList:(NSString*)areaList agencysJob:(CGFloat)agencysJob headQuarters:(NSInteger)headQuarters{
    
    if (self = [super init]) {
        
        _createPerson = createPerson;
        _companyLogo = companyLogo;
        _companyName = companyName;
        _companyNumber = companyNumber;
        _companySlogan = companySlogan;
        _areaList = areaList;
        _agencysJob = agencysJob;
        _headQuarters = headQuarters;
        
    }
    return self;
}

-(NSString*)requestUrl{
    
    return CreateCompanyUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"createPerson":[NSNumber numberWithFloat:_createPerson],
             @"companyLogo":_companyLogo,
             @"companyName":_companyName,
             @"companyNumber":_companyNumber,
             @"companySlogan": _companySlogan,
             @"areaList":_areaList,
             @"agencysJob":[NSNumber numberWithFloat:_agencysJob],
             @"headQuarters":[NSNumber numberWithInteger:_headQuarters]
             };
}

@end
