//
//  AppDelegate.h
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "SNTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SNTabBarController *appRootTabBarVC;


- (void)sendPay_demo:(NSString *)orderNum andName:(NSString *)name andPrice:(NSString *)price andExtend:(NSString *)callBackUrl;

// 微信支付 (现在自己的页面掉接口将返回的数据包装成字典传进来)
- (void)WXPayWithDic:(NSDictionary *)dic;

// 支付宝支付 (现在自己的页面掉接口将返回的数据包装成字典传进来)
- (void)ALiPayWithDic:(NSDictionary *)dic;


- (void)setUPJPUSH;
@end

