//
//  BLEJBudgetGuideCell.h
//  Calculator
//
//  Created by 赵春浩 on 17/4/27.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLEJBudgetGuideCellDelegate <NSObject>

@optional
- (void)didClickSendTestCodeBtnWithPhoneNumber:(NSString *)phoneNum withBtn:(UIButton *)btn;
- (void)didClickSelectRoomCount:(NSInteger)count andTitle:(NSString *)title andCurrentIndex:(NSInteger)index andShowZero:(BOOL)showZero;

@end

@interface BLEJBudgetGuideCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
// 面积输入框
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *textFieldImageVerificationCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImageVerificationCode;

@property (weak, nonatomic) IBOutlet UIButton *sittingRoomBtn;
@property (weak, nonatomic) IBOutlet UIButton *bedroomBtn;
@property (weak, nonatomic) IBOutlet UIButton *diningRoomBtn;
@property (weak, nonatomic) IBOutlet UIButton *kitchenBtn;
@property (weak, nonatomic) IBOutlet UIButton *bathroomBtn;
@property (weak, nonatomic) IBOutlet UIButton *balconyBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *testCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendTestCodeBtn;

@property (weak, nonatomic) id<BLEJBudgetGuideCellDelegate> BLEJBudgetGuideCellDelegate;
// 是否显示手机号验证码
@property (assign, nonatomic) BOOL isShowTelNum;

@property (strong, nonatomic) UIButton *currentBtn;

@end
