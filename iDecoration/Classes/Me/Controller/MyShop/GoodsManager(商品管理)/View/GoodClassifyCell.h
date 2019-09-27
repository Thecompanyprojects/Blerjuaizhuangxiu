//
//  GoodClassifyCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyModel.h"

@interface GoodClassifyCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) ClassifyModel *model;
@end
