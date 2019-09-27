//
//  CompanyLogoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/24.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyLogoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (copy, nonatomic) void(^modifyBlock)();

@end
