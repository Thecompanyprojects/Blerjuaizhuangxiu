//
//  CelebrityInterviewsListViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/19.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CelebrityInterviewsListViewController : UIViewController
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *arrayButtonTop;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
