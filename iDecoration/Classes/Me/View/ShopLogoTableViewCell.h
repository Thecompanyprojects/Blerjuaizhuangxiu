//
//  ShopLogoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/3/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopLogoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *openMemberBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberDetailBtn;

@property (nonatomic, copy) void(^openBlock)();
@property (nonatomic, copy) void(^detailBlock)();


@end
