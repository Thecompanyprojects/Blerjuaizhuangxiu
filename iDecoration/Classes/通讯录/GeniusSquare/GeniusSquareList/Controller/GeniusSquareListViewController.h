//
//  GeniusSquareListViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EliteListViewController.h"

@interface GeniusSquareListViewController : UIViewController
@property (copy, nonatomic) NSString *controllerTitle;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *countyId;
@property (strong, nonatomic) NSMutableArray *arrayData;

@end
