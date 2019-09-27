//
//  AppleIAPManager.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppleIAPManager : NSObject

+ (instancetype)sharedManager;

- (void)buyFlowerWithIAP:(NSString *)identifer completion:(void(^)(NSString *orderId))completion;

//  identifer 传 大锦旗
- (void)buyBannerWithIAP:(NSString *)identifer completion:(void(^)(NSString *orderId))completion;;
@end
