//
//  localcommunityVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void (^ReturnValueBlock) (NSString *strValue);

@interface localcommunityVC : SNViewController
@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *countyId;
@property (nonatomic,assign) BOOL ischange;
@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,assign) BOOL isfromsite;
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

@end
