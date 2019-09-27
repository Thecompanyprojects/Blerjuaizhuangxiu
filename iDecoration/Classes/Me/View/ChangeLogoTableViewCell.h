//
//  ChangeLogoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeLogoTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;

@property (weak, nonatomic) IBOutlet UIButton *publicBtn;
- (IBAction)publicBtnClick:(UIButton *)sender;


@property (nonatomic, copy) void(^changeLogoBlock)();
@property (nonatomic, copy) void(^changePublicTag)();

@end
