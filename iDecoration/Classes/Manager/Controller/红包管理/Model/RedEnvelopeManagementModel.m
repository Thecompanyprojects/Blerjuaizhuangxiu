//
//  RedEnvelopeManagementModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "RedEnvelopeManagementModel.h"

static NSArray *_arrayTitle;
static NSArray *_arrayTitleIcon;

@implementation RedEnvelopeManagementModel
+ (NSArray *)arrayTitle {
    return @[@"促销券", @"转发抢红包", @"扫码抢红包", @"普通红包", @"功能暗藏红包", @"大转盘", @"刮刮卡"];
}

+ (NSArray *)arrayTitleIcon {
    return @[@"icon_daijingquan", @"icon_zhuangfa", @"icon_saoma", @"icon_putong", @"icon_gneng", @"icon_dazhuangpan", @"icon_guaguaka"];
}
@end
