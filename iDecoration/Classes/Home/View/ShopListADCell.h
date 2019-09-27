//
//  ShopListADCell.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface ShopListADCell : UITableViewCell

//@property (nonatomic, strong) UIImageView *adImage;
@property (nonatomic, strong) SDCycleScrollView *adImage;

@property (nonatomic, strong) NSArray *hrefArray;

@property (nonatomic, copy) void(^gotoAdWebBlock)(NSString *hrfString);
@end
