//
//  DecorateInfoNeedView.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecorateInfoNeedView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewHeightCon;

@property (weak, nonatomic) IBOutlet UITextField *itemTF;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *vertifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendVertifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *areaTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;

@property (weak, nonatomic) IBOutlet UIButton *finishButton;

// 省编号
@property (nonatomic, strong) NSString *provinceNum;
// 市编号
@property (nonatomic, strong) NSString *cityNum;
// 区县编号
@property (nonatomic, strong) NSString *countyNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protocolImageTopToPhoneTFCon;


@property (nonatomic, copy) void (^sendVertifyCodeBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelHeight;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTFHeightCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTFHeightCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneTFHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vertifyCodeTFHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *areaTFHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TimeTFHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishBtnHeightCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendVerfifyBtnWidhtCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protocolImageToVertifyTFCon;
@property (weak, nonatomic) IBOutlet UITextField *textFieldImageVerificationCode;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImageVerificationCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tfIVCHeight;











@end
