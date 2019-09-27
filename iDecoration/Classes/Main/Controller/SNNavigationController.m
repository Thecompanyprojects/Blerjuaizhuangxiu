//
//  SNNavigationController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNNavigationController.h"
#import "UIBarButtonItem+Item.h"

@interface SNNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation SNNavigationController


+ (void)load {
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 设置导航条标题 => UINavigationBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBarTintColor:[UIColor hexStringToColor:@"30ee82"]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back1) name:@"back" object:nil];
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
//
//    [self.view addGestureRecognizer:pan];
//
//    //只有非根控制器才需要触发手势
//    pan.delegate = self;
//
//    // 禁止之前手势
//    self.interactivePopGestureRecognizer.enabled = YES;
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
//// 决定是否触发手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//
////        return self.childViewControllers.count > 1;
//    return NO;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果根控制器也要返回手势有效, 就会造成假死状态
    // 所以, 需要过滤根控制器
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) { // 非根控制器
        
        // 恢复滑动返回功能
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 设置返回按钮,只有非根控制器
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"tui2"] highImage:[UIImage imageNamed:@"back"]  target:self action:@selector(back)];
    }
    
    // 真正在跳转
   [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
}


- (void)back1 {
    
    [self popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}







@end
