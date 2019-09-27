//
//  BannerListCell.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BannerListModel.h"

@interface BannerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leaveWordsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaveWordsTopToImageViewCon;

@property (nonatomic, strong) BannerListModel  *bannerListModel;

@property (nonatomic, copy) void(^IconIVTapBlock)();
@end
