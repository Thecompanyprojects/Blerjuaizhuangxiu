//
//  CreateShopApi.m
//  iDecoration
//
//  Created by RealSeven on 2017/4/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "CreateShopApi.h"

@implementation CreateShopApi
{
    NSInteger _merchantId;//店铺Id（-1）
    NSString *_merchantLogo;//店铺Logo
    NSString *_merchantName;//店铺名称
    NSString *_typeNo;//店铺类型
    NSString *_merchantlandline;//座机号
    NSString *_address;//详细地址
    NSString *_merchantPhone;//电话
    NSString *_merchantWx;//微信号
    NSString *_detail;//详情
    NSInteger _createPersonId;//操作人Id
    NSInteger _relType;//关联类型
    NSInteger _relId;//关联Id
    NSString *_provinceId;//省份Id
    NSString *_cityId;//城市Id
    NSString *_countyId;//区县Id
    NSInteger _seeFlag;//关联Id
}


-(id)initWithMerchantId:(NSInteger)merchantId merchantLogo:(NSString *)merchantLogo merchantName:(NSString *)merchantName typeNo:(NSString *)typeNo merchantlandline:(NSString *)merchantlandline address:(NSString *)address merchantPhone:(NSString *)merchantPhone merchantWx:(NSString *)merchantWx detail:(NSString *)detail createPersonId:(NSInteger)createPersonId relType:(NSInteger)relType relId:(NSInteger)relId provinceId:(NSString*)provinceId cityId:(NSString*)cityId countyId:(NSString*)countyId seeFlag:(NSInteger)seeFlag{
    
    if (self = [super init]) {
        
        _merchantId = merchantId;
        _merchantLogo = merchantLogo;
        _merchantName = merchantName;
        _typeNo = typeNo;
        _merchantlandline = merchantlandline;
        _address = address;
        _merchantPhone = merchantPhone;
        _merchantWx = merchantWx;
        _detail = detail;
        _createPersonId = createPersonId;
        _relType = relType;
        _relId = relId;
        _provinceId = provinceId;
        _cityId = cityId;
        _countyId = countyId;
        _seeFlag = seeFlag;
    }
    return self;
}

-(NSString*)requestUrl{
    
    return CreateShopUrl;
}

-(YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

-(id)requestArgument{
    
    return     @{@"merchantId":[NSNumber numberWithInteger:_merchantId],
                 @"merchantLogo":_merchantLogo,
                 @"merchantName":_merchantName,
                 @"typeNo":_typeNo,
                 @"merchantlandline":_merchantlandline,
                 @"address":_address,
                 @"merchantPhone":_merchantPhone,
                 @"merchantWx":_merchantWx,
                 @"detail":_detail,
                 @"createPersonId":[NSNumber numberWithInteger:_createPersonId],
                 @"relType":[NSNumber numberWithInteger:_relType],
                 @"relId":[NSNumber numberWithInteger:_relId],
                 @"provinceId":_provinceId,
                 @"cityId":_cityId,
                 @"countyId":_countyId,
                 @"seeFlag":[NSNumber numberWithInteger:_seeFlag]
                 };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"Referer":kReferer};
}

@end
