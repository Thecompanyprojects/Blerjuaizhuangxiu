//
//  SendFlowersViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewMyPersonCardTwoCell;

@interface SendFlowersViewController : UIViewController
typedef void(^SendFlowersViewControllerBlock)(BOOL isPay);
@property (copy, nonatomic) NSString *agencyId;
@property (copy, nonatomic) NSString *compamyIDD;
@property (assign, nonatomic)BOOL isCompamyID;
@property (strong, nonatomic) NewMyPersonCardTwoCell *cell;
@property (copy, nonatomic) SendFlowersViewControllerBlock blockIsPay;

@end
