//
//  MyOrderViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/4/12.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "MyOrderViewController.h"
#import <WMPageController.h>
#import "MyOrderPageController.h"


@interface MyOrderViewController ()<WMPageControllerDelegate, WMPageControllerDataSource>

@property (nonatomic, strong) WMPageController *pageController;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    
    [self.view addSubview:self.pageController.view];
    
    if (IphoneX) {
        self.pageController.viewFrame = CGRectMake(0, 84, kSCREEN_WIDTH, kSCREEN_HEIGHT-84);
    } else {
        self.pageController.viewFrame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64);
    }
    
}



#pragma mark - WMPageController
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    MyOrderPageController *allVC = [MyOrderPageController new];
    allVC.navigationController = self.navigationController;
    allVC.orderType = index;
    allVC.agencyId = self.agencyId;
    return @[allVC, allVC, allVC][index];
    
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}


#pragma mark - lazyMethod
- (WMPageController *)pageController {
    if (!_pageController) {
        _pageController = [[WMPageController alloc] init];
        _pageController.menuHeight = 40;
        _pageController.menuBGColor = [UIColor whiteColor];
        _pageController.menuView.backgroundColor = [UIColor whiteColor];
        _pageController.titleColorNormal = [UIColor blackColor];
        _pageController.titleColorSelected = kMainThemeColor;
        _pageController.titleSizeNormal = 16;
        _pageController.titleSizeSelected = 16;
        _pageController.delegate = self;
        _pageController.dataSource = self;
    }
    return _pageController;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"全部", @"待确认", @"已确认"];
    }
    return _titles;
}

@end
