//
//  ZCHcouponCashCell.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/12/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCHCouponModel.h"

@interface ZCHcouponCashCell : UITableViewCell

@property (strong, nonatomic) ZCHCouponModel *model;
@property (strong, nonatomic) ZCHCouponModel *myModel;


-(void)configData:(id)data;
@end
