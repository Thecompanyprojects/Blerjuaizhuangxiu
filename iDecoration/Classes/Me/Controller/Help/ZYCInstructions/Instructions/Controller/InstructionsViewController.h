//
//  InstructionsViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCHPublicWebViewController.h"
#import "DirectionModel.h"

@interface InstructionsViewController : UIViewController
typedef enum{
    InstructionsViewControllerTypeMain,//使用说明主页面
    InstructionsViewControllerTypeVersion,//版本说明
} InstructionsViewControllerType;
@property (assign, nonatomic) InstructionsViewControllerType controllerType;
@property (strong, nonatomic) UITableView *tableView;
@end
