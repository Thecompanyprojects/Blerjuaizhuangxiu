//
//  ZCHUploadCooperateCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCHUploadCooperateCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightCons;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopCon;

@end
