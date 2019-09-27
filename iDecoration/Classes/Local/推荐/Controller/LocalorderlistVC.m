//
//  LocalorderlistVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "LocalorderlistVC.h"
#import "yearorderlistVC.h"
#import "monthorderlistVC.h"
#import "weekorderlistVC.h"
#import <ICPagingManager/ICPagingManager.h>

@interface LocalorderlistVC ()<ICPagingManagerProtocol>
@property (nonatomic, strong) ICPagingManager *manager;
@end

@implementation LocalorderlistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收单排行榜";
    
    self.manager = [ICPagingManager manager];
    self.manager.delegate = self;
    [self.manager loadPagingWithConfig:^(ICSegmentBarConfig *config)
     {
         config.nor_color([UIColor hexStringToColor:@"DDDDDD"]);
         config.sel_color([UIColor whiteColor]);
         config.line_color([UIColor whiteColor]);
         config.backgroundColor = [UIColor hexStringToColor:@"4ABD87"];
         config.titleFont = 16;
     }];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    for (UIView *view in backgroundView.subviews) {
        if (CGRectGetHeight([view frame]) <= 1) {
            view.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ICPagingComponentBarStyle)style
{
    return ICPagingComponentStyleNormal;
}

/**
 
 控制器集合
 @return 控制器集合
 */
- (NSArray<UIViewController *> *)pagingControllerComponentChildViewControllers
{
    yearorderlistVC *vc0 = [yearorderlistVC new];
    vc0.cityId = self.cityId;
    vc0.countryId = self.countryId;
    monthorderlistVC *vc1 = [monthorderlistVC new];
    vc1.cityId = self.cityId;
    vc1.countryId = self.countryId;
    weekorderlistVC *vc2 = [weekorderlistVC new];
    vc2.cityId = self.cityId;
    vc2.countryId = self.countryId;

    NSArray *array = @[vc0,vc1,vc2];
    return array;
}

/**
 选项卡标题
 
 @return @[]
 */
- (NSArray<NSString *> *)pagingControllerComponentSegmentTitles
{
    return @[@"年度排行",
             @"月度排行",
             @"周度排行"];
}

/**
 选项卡位置 适配iPhone X 则减去88
 
 @return rect
 */
- (CGRect)pagingControllerComponentSegmentFrame
{
    return CGRectMake(0, kNaviBottom, self.view.bounds.size.width, 50);
}

/**
 选项卡位置 中间控制器view 高度
 
 @return CGFloat
 */
- (CGFloat)pagingControllerComponentContainerViewHeight
{
    return self.view.bounds.size.height - kNaviBottom;
}


@end
