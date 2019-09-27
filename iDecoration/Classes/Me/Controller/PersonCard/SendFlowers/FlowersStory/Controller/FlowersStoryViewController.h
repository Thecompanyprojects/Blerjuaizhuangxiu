//
//  FlowersStoryViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowersStoryViewController : UIViewController
typedef void(^FlowersStoryViewControllerBlock)(NSDictionary *para);
@property (strong, nonatomic) NSString *personId;
@property (copy, nonatomic) FlowersStoryViewControllerBlock blockFinish;
@end
