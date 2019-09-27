//
//  NewMeCell.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/5.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageNumLabel;

@end
