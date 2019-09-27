//
//  IntroductionToMemberPackagesModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/8/31.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntroductionToMemberPackagesModel : NSObject
@property (copy, nonatomic) NSString *adviserName;
@property (copy, nonatomic) NSString *adviserPhone;
@property (copy, nonatomic) NSString *adviserWx;
@property (copy, nonatomic) NSString *adviserQq;
@property (strong, nonatomic) NSArray *arrayData;

@end

NS_ASSUME_NONNULL_END
