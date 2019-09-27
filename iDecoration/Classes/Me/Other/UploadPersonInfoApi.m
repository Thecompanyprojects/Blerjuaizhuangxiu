//
//  UploadPersonInfoApi.m
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "UploadPersonInfoApi.h"

@implementation UploadPersonInfoApi
{
    NSInteger _agencyId;
    NSString *_photo;
//    NSString *_userName;
    NSString *_trueName;
    NSString *_companyJob;
    NSString *_agencySchool;
    NSInteger _gender;
    NSString *_workingDateStr;
    NSString *_agencyBirthdayStr;
    NSInteger _roleTypeId;
    NSString *_comment;
    NSString *_weixin;
//    CGFloat _provinceId;
//    CGFloat _cityId;
//    CGFloat _countyId;
    CGFloat _hometownProvinceId;
    CGFloat _hometownCityId;
    CGFloat _hometownCountyId;
    
    
    NSString *_weixinQR;
    NSString *_emil;
    NSString *_intrdu;
}

-(id)initWithAgencyId:(NSInteger)agencyId photo:(NSString *)photo trueName:(NSString *)trueName gender:(NSInteger)gender workingDateStr:(NSString *)workingDateStr roleTypeId:(NSInteger)roleTypeId comment:(NSString *)comment weixin:(NSString *)weixin hometownProvinceId:(CGFloat)hometownProvinceId hometownCityId:(CGFloat)hometownCityId hometownCountyId:(NSString *)hometownCountyId companyJob:(NSString *)companyJob agencySchool:(NSString *)agencySchool agencyBirthdayStr:(NSString *)agencyBirthdayStr weixinQR:(NSString *)weixinQR emil:(NSString *)emil intrdu:(NSString *)intrdu{
    
    if (self = [super init]) {
        
        _agencyId = agencyId;
        _photo = photo;
//        _userName = userName;
        _trueName = trueName;
        _gender = gender;
        _workingDateStr = workingDateStr;
        _roleTypeId = roleTypeId;
        _comment = comment;
        _weixin = weixin;
//        _provinceId = provinceId;
//        _cityId = cityId;
//        _countyId = countyId;
        _hometownProvinceId = hometownProvinceId;
        _hometownCityId = hometownCityId;
        _hometownCountyId = [hometownCountyId floatValue];
        _companyJob = companyJob;
        _agencySchool = agencySchool;
        _agencyBirthdayStr = agencyBirthdayStr;
        
        _weixinQR = weixinQR;
        _emil = emil;
        _intrdu = intrdu;
        
    }
    return self;
}

-(NSString*)requestUrl{
    
    return UploadPersonInfoUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return @{
             @"agencyId": [NSNumber numberWithInteger:_agencyId],
             @"photo": _photo,
//             @"userName": _userName,
             @"trueName": _trueName,
             @"gender": [NSNumber numberWithInteger:_gender],
             @"workingDateStr": _workingDateStr,
             // 修改职位 现在不需要了
//             @"roleTypeId": [NSNumber numberWithInteger:_roleTypeId],
             @"comment": _comment,
             @"weixin": _weixin,
//             @"provinceId": [NSNumber numberWithFloat:_provinceId],
//             @"cityId": [NSNumber numberWithFloat:_cityId],
//             @"countyId": [NSNumber numberWithFloat:_countyId],
             @"hometownProvinceId": [NSNumber numberWithFloat:_hometownProvinceId],
             @"hometownCityId": [NSNumber numberWithFloat:_hometownCityId],
             @"hometownCountyId": [NSNumber numberWithFloat:_hometownCountyId],
             @"companyJob": _companyJob,
             @"agencySchool": _agencySchool,
             @"agencyBirthdayStr": _agencyBirthdayStr,
             
             @"email": _emil,
             @"indu": _intrdu,
             @"wxQrcode": _weixinQR
             };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}


@end
