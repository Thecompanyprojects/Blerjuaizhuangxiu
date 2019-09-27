//
//  ActivityManageTwoCell.h
//  iDecoration
//
//  Created by sty on 2017/10/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityManageTwoCell : UITableViewCell
@property (nonatomic, copy) void(^editActBlock)();
@property (nonatomic, copy) void(^manageActBlock)();
@property (nonatomic, copy) void(^shareActBlock)();


- (IBAction)EditBtnClick:(UIButton *)sender;
- (IBAction)manageBtnClick:(UIButton *)sender;
- (IBAction)shareBtnClick:(UIButton *)sender;

@end
