//
//  rankingModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rankingModel : NSObject
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, assign) NSInteger appVip;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, copy) NSString *counts;
@end
