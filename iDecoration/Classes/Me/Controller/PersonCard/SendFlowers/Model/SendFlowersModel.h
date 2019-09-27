//
//  SendFlowersModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendFlowersModel : NSObject
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (strong, nonatomic) NSArray *arrayImageIconName;
@property (strong, nonatomic) NSArray *arrayStringTitle;
@property (strong, nonatomic) NSArray *arrayStringDetail;
@property (strong, nonatomic) NSArray *arrayStringPrice;
/**
 是否被选中
 */
@property (assign, nonatomic) BOOL isSelected;

/**
 每一行鲜花的图标
 */
@property (strong, nonatomic) UIImage *imageIcon;

/**
 每一行鲜花的数目 🌰@"一朵"@"一束"
 */
@property (copy, nonatomic) NSString *stringTitle;

/**
 每一行鲜花的数目后面的详细注解🌰@"一束(12朵)"
 */
@property (copy, nonatomic) NSString *stringDetail;

/**
 价格 🌰¥1.0  优惠价¥8.0
 */
@property (copy, nonatomic) NSString *stringPrice;

+ (instancetype)sharedInstance;
@end
