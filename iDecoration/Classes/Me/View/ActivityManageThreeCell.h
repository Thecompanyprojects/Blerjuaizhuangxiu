//
//  ActivityManageThreeCell.h
//  iDecoration
//
//  Created by sty on 2017/10/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityManageThreeCell : UITableViewCell

@property (nonatomic, copy) void(^colseActBlock)();
@property (nonatomic, copy) void(^lookActBlock)();
@property (nonatomic, copy) void(^republicActBlock)();

@property (weak, nonatomic) IBOutlet UIButton *colseSignUpBtn;

- (IBAction)closeBtnClick:(UIButton *)sender;

- (IBAction)checkDetailBtnClick:(UIButton *)sender;
- (IBAction)rePublicBtnClick:(UIButton *)sender;

@end
