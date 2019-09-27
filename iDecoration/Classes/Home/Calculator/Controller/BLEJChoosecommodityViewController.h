//
//  BLEJChoosecommodityViewController.h
//  iDecoration
//
//  Created by john wall on 2018/8/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RefreshBlockchoose)(NSInteger goodID,NSString *picurl,NSString *merchanName,NSString *goodPrice);
@interface BLEJChoosecommodityViewController : UIViewController
@property(nonatomic,strong)NSString *companyID;

@property(copy,nonatomic)RefreshBlockchoose blockchoose;
@end
