//
//  ActivitySignUpSettingCell.h
//  iDecoration
//
//  Created by sty on 2017/10/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivitySignUpSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
- (IBAction)deleteBtnClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnClick:(UIButton *)sender;


@property (nonatomic, strong) void(^deleteBlock)(NSInteger tag);
@property (nonatomic, strong) void(^sureBlock)(NSInteger tag);

@end
