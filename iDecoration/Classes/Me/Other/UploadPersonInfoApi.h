//
//  UploadPersonInfoApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface UploadPersonInfoApi : YTKRequest

//-(id)initWithAgencyId:(NSInteger)agencyId photo:(NSString *)photo userName:(NSString *)userName trueName:(NSString *)trueName gender:(NSInteger)gender workingDateStr:(NSString *)workingDateStr roleTypeId:(NSInteger)roleTypeId comment:(NSString *)comment weixin:(NSString *)weixin provinceId:(CGFloat)provinceId cityId:(CGFloat)cityId countyId:(CGFloat)countyId hometownProvinceId:(CGFloat)hometownProvinceId hometownCityId:(CGFloat)hometownCityId hometownCountyId:(CGFloat)hometownCountyId;

-(id)initWithAgencyId:(NSInteger)agencyId photo:(NSString *)photo trueName:(NSString *)trueName gender:(NSInteger)gender workingDateStr:(NSString *)workingDateStr roleTypeId:(NSInteger)roleTypeId comment:(NSString *)comment weixin:(NSString *)weixin hometownProvinceId:(CGFloat)hometownProvinceId hometownCityId:(CGFloat)hometownCityId hometownCountyId:(NSString *)hometownCountyId companyJob:(NSString *)companyJob agencySchool:(NSString *)agencySchool agencyBirthdayStr:(NSString *)agencyBirthdayStr weixinQR:(NSString *)weixinQR emil:(NSString *)emil intrdu:(NSString *)intrdu;

@end
