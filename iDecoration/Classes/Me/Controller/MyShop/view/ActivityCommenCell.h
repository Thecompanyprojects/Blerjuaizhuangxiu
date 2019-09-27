//
//  ActivityCommenCell.h
//  iDecoration
//
//  Created by sty on 2018/3/7.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCommenCell : UITableViewCell
@property (nonatomic, strong) UIView *activitySignUpV;//活动报名的view
@property (nonatomic, strong) UIButton *activitySignUpBtn;

@property (nonatomic, strong) UIImageView *SignUpBigPlacholdV;//大的报名图标
@property (nonatomic, strong) UILabel *SignStartTimeL;//活动开始时间
@property (nonatomic, strong) UILabel *SignEndTimeL;//活动结束时间
@property (nonatomic, strong) UILabel *SignUpNumL;//活动报名人数

-(void)configWith:(NSString *)actStartTime actEndTime:(NSString *)actEndTime haveSignUp:(NSString *)haveSignUp signUpNum:(NSString *)signUpNum isHaveActivity:(BOOL)isHaveActivity;
+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
