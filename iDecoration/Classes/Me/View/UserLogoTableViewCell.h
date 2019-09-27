//
//  UserLogoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/2/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLogoTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *MemberNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *RegAndLoginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;

@property (nonatomic, copy) void (^regAndLoginBlock)(void);
@property (nonatomic, copy) void (^logoBlock)(void);
@property (nonatomic, copy) void (^vipActionBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *vipButton;

@end
