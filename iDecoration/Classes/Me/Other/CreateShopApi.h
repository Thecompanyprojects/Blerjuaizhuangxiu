//
//  CreateShopApi.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface CreateShopApi : YTKRequest

-(id)initWithMerchantId:(NSInteger)merchantId merchantLogo:(NSString*)merchantLogo merchantName:(NSString*)merchantName typeNo:(NSString *)typeNo merchantlandline:(NSString*)merchantlandline address:(NSString*)address merchantPhone:(NSString*)merchantPhone merchantWx:(NSString*)merchantWx detail:(NSString*)detail createPersonId:(NSInteger)createPersonId relType:(NSInteger)relType relId:(NSInteger)relId provinceId:(NSString*)provinceId cityId:(NSString*)cityId countyId:(NSString*)countyId seeFlag:(NSInteger)seeFlag;

@end
