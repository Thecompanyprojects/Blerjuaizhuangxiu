//
//  DateStatisticsViewController.m
//  iDecoration
//
//  Created by zuxi li on 2017/10/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "DateStatisticsViewController.h"
#import "YellowPageStatisticsViewController.h"
#import "ConstructionSiteStatisticsViewController.h"
#import "GoodsStatisticsViewController.h"
#import "HeadOfficeDateStatisticsViewController.h"

@interface DateStatisticsViewController ()

@end

@implementation DateStatisticsViewController
- (instancetype)init {
    if (self = [super init]) {
        self.menuHeight = 40;
        self.menuBGColor = kBackgroundColor;
        self.titleSizeNormal = 16;
        self.titleSizeSelected = 16;
        self.titleColorSelected = kMainThemeColor;
        self.automaticallyCalculatesItemWidths = YES;
        self.cachePolicy = WMPageControllerCachePolicyDisabled;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"数据统计";
    
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (self.isHeadOffice) {
        HeadOfficeDateStatisticsViewController *headVC = [[HeadOfficeDateStatisticsViewController alloc] init];
        headVC.headCompanyDateModelArray = self.headCompanyDateModelArray;
        headVC.selectedIndex = index;
        return headVC;
    } else {
        if (self.isShop) {
            //企业
            YellowPageStatisticsViewController *yellowPageVC = [UIStoryboard storyboardWithName:@"YellowPageStatisticsViewController" bundle:nil].instantiateInitialViewController;
            yellowPageVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 工地
            ConstructionSiteStatisticsViewController *constructionSiteVC =  [UIStoryboard storyboardWithName:@"ConstructionSiteStatisticsViewController" bundle:nil].instantiateInitialViewController;
            constructionSiteVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 商品
            GoodsStatisticsViewController *goodsVC = [UIStoryboard storyboardWithName:@"GoodsStatisticsViewController" bundle:nil].instantiateInitialViewController;
            goodsVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 预约
            GoodsStatisticsViewController *needDecorateVC = [UIStoryboard storyboardWithName:@"GoodsStatisticsViewController" bundle:nil].instantiateInitialViewController;
            needDecorateVC.controllerType = 999;
            needDecorateVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 活动
            ConstructionSiteStatisticsViewController *activityVC =  [UIStoryboard storyboardWithName:@"ConstructionSiteStatisticsViewController" bundle:nil].instantiateInitialViewController;
            activityVC.controllerType = 98;
            activityVC.sonCompanyDateModel = self.sonCompanyDateModel;
            return @[yellowPageVC, constructionSiteVC, goodsVC, needDecorateVC, activityVC][index];
        } else {
            //企业
            YellowPageStatisticsViewController *yellowPageVC = [UIStoryboard storyboardWithName:@"YellowPageStatisticsViewController" bundle:nil].instantiateInitialViewController;
            yellowPageVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 工地
            ConstructionSiteStatisticsViewController *constructionSiteVC =  [UIStoryboard storyboardWithName:@"ConstructionSiteStatisticsViewController" bundle:nil].instantiateInitialViewController;
            constructionSiteVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 计算器
            ConstructionSiteStatisticsViewController *calculateSiteVC =  [UIStoryboard storyboardWithName:@"ConstructionSiteStatisticsViewController" bundle:nil].instantiateInitialViewController;
            calculateSiteVC.controllerType = 99;
            calculateSiteVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 喊装修
            GoodsStatisticsViewController *needDecorateVC = [UIStoryboard storyboardWithName:@"GoodsStatisticsViewController" bundle:nil].instantiateInitialViewController;
            needDecorateVC.controllerType = 99;
            needDecorateVC.sonCompanyDateModel = self.sonCompanyDateModel;
            // 活动
            ConstructionSiteStatisticsViewController *activityVC =  [UIStoryboard storyboardWithName:@"ConstructionSiteStatisticsViewController" bundle:nil].instantiateInitialViewController;
            activityVC.controllerType = 98;
            activityVC.sonCompanyDateModel = self.sonCompanyDateModel;
            return @[yellowPageVC, constructionSiteVC, calculateSiteVC, needDecorateVC, activityVC][index];
        }
    }
   
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

@end












































