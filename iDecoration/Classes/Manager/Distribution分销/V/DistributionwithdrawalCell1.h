//
//  DistributionwithdrawalCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/8.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaText.h"
@interface DistributionwithdrawalCell1 : UITableViewCell
@property (nonatomic,strong) NaText *moneyText;
-(void)setdata:(NSString *)accountTotal;
@end
