//
//  MessageNotiTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageNotiTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;

@property (nonatomic, copy) void(^switchBlock)(BOOL isOn);
@end
