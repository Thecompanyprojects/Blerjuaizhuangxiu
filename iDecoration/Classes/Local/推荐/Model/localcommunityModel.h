//
//  localcommunityModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface localcommunityModel : NSObject
@property (nonatomic , assign) NSInteger              communityId;
@property (nonatomic , copy) NSString              * longitude;
@property (nonatomic , copy) NSString              * covermap;
@property (nonatomic , copy) NSString              * countyId;
@property (nonatomic , copy) NSString              * latitude;
@property (nonatomic , assign) NSInteger              mobelCount;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              consCount;
@property (nonatomic , copy) NSString              * provinceId;
@property (nonatomic , copy) NSString              * cityId;
@property (nonatomic , copy) NSString              * attribution;
@property (nonatomic , copy) NSString              * communityName;
@property (nonatomic , copy) NSString              * companyId;
@end

NS_ASSUME_NONNULL_END
