//
//  HomeBroadcastListViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/9.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOfHomeBroadcast.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeBroadcastListViewController : UIViewController
@property (strong, nonatomic) NetworkOfHomeBroadcast *modelCompany;
@property (strong, nonatomic) NetworkOfHomeBroadcast *modelEmployee;
@end

NS_ASSUME_NONNULL_END
