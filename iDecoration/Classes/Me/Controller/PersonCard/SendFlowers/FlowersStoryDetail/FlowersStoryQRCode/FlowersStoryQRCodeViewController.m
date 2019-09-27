//
//  FlowersStoryQRCodeViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "FlowersStoryQRCodeViewController.h"

@interface FlowersStoryQRCodeViewController ()

@end

@implementation FlowersStoryQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (isiPhoneX) {
        self.imageViewTopToTop.constant = 88 + 15;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.layoutHeight enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *constraint = obj;
        constraint.constant = Height_Layout(constraint.constant);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
