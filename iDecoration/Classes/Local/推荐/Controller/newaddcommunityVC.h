//
//  newaddcommunityVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/29.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "SNViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ReturnValueBlock) (NSString *strValue);


@interface newaddcommunityVC : SNViewController
@property (nonatomic,copy) NSString *companyId;
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *countyId;
@end

NS_ASSUME_NONNULL_END
