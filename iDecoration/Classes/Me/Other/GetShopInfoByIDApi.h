//
//  GetShopInfoByIDApi.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface GetShopInfoByIDApi : YTKRequest

-(id)initWithMerchantId:(NSString*)merchantId;

@end
