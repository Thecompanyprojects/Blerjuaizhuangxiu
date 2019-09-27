//
//  PushToLocalViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "PushToLocalViewController.h"
#import "WriteStoryViewController.h"

@interface PushToLocalViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;

@end

@implementation PushToLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送同城";
    self.buttonSend.layer.cornerRadius = 5.0f;
    self.buttonSend.layer.masksToBounds = true;
}

- (IBAction)didTouchButtonSend:(UIButton *)sender {
    WriteStoryViewController *controller = [WriteStoryViewController new];
    controller.companyId = self.companyId;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
