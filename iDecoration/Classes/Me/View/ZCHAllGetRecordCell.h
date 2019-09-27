//
//  ZCHAllGetRecordCell.h
//  iDecoration
//
//  Created by 赵春浩 on 2018/1/3.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCHCouponGettingRecordModel.h"

@interface ZCHAllGetRecordCell : UITableViewCell

@property (strong, nonatomic) ZCHCouponGettingRecordModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelGiftNameHeight;

@end
