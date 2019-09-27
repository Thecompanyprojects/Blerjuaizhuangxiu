//
//  YellowPageActivityCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YellowPageActivityCell : UITableViewCell
typedef void(^YellowPageActivityCellBlock)(NSString *string);
@property (copy, nonatomic) YellowPageActivityCellBlock block;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicHeightconstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paomaViewConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *AlreadysignupBtn;

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *paoMaView;
@property (weak, nonatomic) IBOutlet UILabel *signUpNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *vertifyCodeTF;

@property (weak, nonatomic) IBOutlet UIView *dynamicView;


@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *activityDetailButton;

@property (weak, nonatomic) IBOutlet UITextField *textFieldImageVerificationCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImageVerificationCode;
@property(assign,nonatomic)CGFloat cellHeightExceptImageHeightAndNotNecessaryTFFrame;



// 立即报名
@property (nonatomic, copy) void(^signUpNowBlock)(YellowPageActivityCell *cell);
// 活动详情
@property (nonatomic, copy) void(^activityDetailBlock)(YellowPageActivityCell *cell);

// 获取验证码
@property (nonatomic, copy) void(^getVeitifyCodeBlock)(YellowPageActivityCell *cell);
@end
