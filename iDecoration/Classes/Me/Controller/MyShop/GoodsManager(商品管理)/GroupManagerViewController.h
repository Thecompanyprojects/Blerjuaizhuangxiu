//
//  GroupManagerViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface GroupManagerViewController : SNViewController
@property (nonatomic, strong) NSString *shopId;
@property (nonatomic, copy) void(^ClasifyBrushBloack)();


@end
