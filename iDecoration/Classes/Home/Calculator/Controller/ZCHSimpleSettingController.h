//
//  ZCHSimpleSettingController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

typedef void(^RefreshBlocksetting)(void);

@interface ZCHSimpleSettingController : SNViewController

// 简装(1: 简装  0 : 精装)
@property (assign, nonatomic) BOOL isSimple;
@property (copy, nonatomic) NSString *companyId;
@property (copy, nonatomic) NSString *Calcaultortype;

@property (copy, nonatomic) RefreshBlocksetting refreshBlock;


@end
