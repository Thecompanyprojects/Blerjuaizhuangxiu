//
//  NetworkManagementModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/7/18.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManagementModel : NSObject

/**
 titleArray
 */
@property (strong, nonatomic, class, readonly) NSArray *arrayTitle;
/**
 imageArray
 */
@property (strong, nonatomic, class, readonly) NSArray *arrayImage;
@end

NS_ASSUME_NONNULL_END
