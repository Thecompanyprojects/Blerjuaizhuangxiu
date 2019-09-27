//
//  SNViewController.m
//  iDecoration
//
//  Created by RealSeven on 17/2/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "SNTabBarController.h"

#import "SuspensionAssistiveTouch.h"
#import "ZCHPublicWebViewController.h"
#import "WFSuspendButton.h"


@interface SNViewController ()<WFSuspendedButtonDelegate>{
    SuspensionAssistiveTouch * _assistiveTouch;
    WFSuspendButton *suspendedBtn;
}

@end

@implementation SNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 修改导航栏字体颜色及字体大小
 
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0]}];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11) {
#ifdef __IPHONE_11_0
        if ([[UIScrollView appearance] respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {

            if (@available(iOS 11.0, *)) {
                [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
               
            } else {
                // Fallback on earlier versions
            }
        }
#endif

    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
//    if (@available(iOS 11.0, *)) {
//        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    self.view.backgroundColor = kBackgroundColor;
    
    //    返回按钮颜色
    self.navigationController.navigationBar.tintColor = White_Color;
    //    导航栏颜色
    self.navigationController.navigationBar.barTintColor = Main_Color;
    
    //设置返回按钮设为中文
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc]init];
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    //    如果A控制器的view成为B控制器的view的子控件,那么A控制器成为B控制器的子控制器
    
    SNTabBarController *tabBarVC = [[SNTabBarController alloc]init];
    //    添加子控制器
    
    [self addChildViewController:tabBarVC];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AssistiveClickDoSomeThing)name:kSuspensionViewShowNotificationCLICKName
//                                                  object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addSuspendedButton
{
    suspendedBtn=[WFSuspendButton suspendedButtonWithCGPoint:CGPointMake(self.view.frame.size.width-80, 200) inView:self.view];
    suspendedBtn.sendDelegate=self;
//    suspendedBtn.backgroundColor=[UIColor redColor];
    [suspendedBtn setImage:[UIImage imageNamed:@"Instruction_sus"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 delay:0.3 options:0 animations:^{
//        suspendedBtn.alpha = 0.2;
    } completion:nil];
    [self.view addSubview:suspendedBtn];
}

-(void)SuspendedButtonDisapper{
    [suspendedBtn removeFromSuperview];
    suspendedBtn = nil;
}

#pragma mark - WFSuspendedButtonDelegate

-(void)isButtonTouched{
    
}

//#pragma mark - AssistiveTouch
//- (void)setAssistiveTouch
//{
//    _assistiveTouch = [[SuspensionAssistiveTouch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height/2-25, 50, 50)];
//}
//
//-(void)AssistiveTouchDisMiss{
//    [kNotificationCenter postNotificationName:kSuspensionViewDisNotificationName object:nil];
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    if (windows.count > 1) {
//
//        SuspensionAssistiveTouch *touchView = [windows lastObject];
//        [touchView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        touchView = nil;
//    }
//}
//
//-(void)AssistiveClickDoSomeThing{
//
//}

//-(void)
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
