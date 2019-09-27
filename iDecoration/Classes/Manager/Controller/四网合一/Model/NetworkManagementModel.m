//
//  NetworkManagementModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/7/18.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "NetworkManagementModel.h"

static NSArray *_arrayTitle;
static NSArray *_arrayImage;

@implementation NetworkManagementModel

+ (NSArray *)arrayTitle {
//    return @[@"爱装修App",@"企业小程序", @"PC端管理", @"公众号管理",@"手机网站",@"五网合一说明",];
    return @[@"爱装修App",@"企业小程序", @"PC端管理", @"公众号管理",@"五网合一说明",];
}

+ (NSArray *)arrayImage {
//    return @[@"icon_aizhuangxiu", @"icon_qiye", @"icon_pcguanli",@"icon_gongzhong", @"icon_shouji", @"icon_wuwang"];
        return @[@"icon_aizhuangxiu", @"icon_qiye", @"icon_pcguanli",@"icon_gongzhong", @"icon_wuwang"];
}

@end
