//
//  CreateCompanyViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/2/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface CreateCompanyViewController : SNViewController

@property (nonatomic, strong) UIScrollView *backSrcV;
@property (strong, nonatomic) UILabel *defaultName;
@property (strong, nonatomic) UIImageView *LOGOImageView;
@property (nonatomic, strong) UIView *lineVOne;
@property (strong, nonatomic) UILabel *companyDeName;
@property (strong, nonatomic) UITextField *CompanyNameTF;
@property (nonatomic, strong) UIView *lineVTwo;

@property (strong, nonatomic) UILabel *NumberDeName;
@property (strong, nonatomic) UILabel *CompanyNumberLabel;
@property (nonatomic, strong) UIView *lineVThree;
//@property (strong, nonatomic) UIButton *AreaBtn;
@property (strong, nonatomic) UILabel *defaultSolganL;
@property (strong, nonatomic) UITextView *SloganTV;
@property (strong, nonatomic) UILabel *RemarkLabel;
@property (strong, nonatomic) UIButton *FinishBtn;

@end
