//
//  StaffCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/11/29.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StaffModel.h"

@interface StaffCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobMottoLabel;

// cell高度  18 + 14 + 28 + 12 = 72 + 图片告诉

@property (nonatomic, strong) StaffModel *model;
@end
