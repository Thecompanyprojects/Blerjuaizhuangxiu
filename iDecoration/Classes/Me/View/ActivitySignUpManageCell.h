//
//  ActivitySignUpManageCell.h
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ActivitySignUpManageCell : UITableViewCell
@property (nonatomic, copy) void(^callPhoneBlock)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UILabel *signUpTimeL;
@property (weak, nonatomic) IBOutlet UILabel *signUpContentL;
@property (weak, nonatomic) IBOutlet UILabel *signUpFromL;
@property (weak, nonatomic) IBOutlet UILabel *signUpCodeL;
@property (weak, nonatomic) IBOutlet UILabel *signUpPhoneL;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;

- (IBAction)callPhoneBtn:(UIButton *)sender;

-(void)configData:(id)data;
@end
