//
//  CalculatorSetTopView.h
//  iDecoration
//
//  Created by zuxi li on 2018/3/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"


@interface CalculatorSetTopView : BaseView
@property (nonatomic, strong) UIImageView *companyIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *simpleSetBtn;
@property (nonatomic, strong) UIButton *hardcoverSetBtn;
@property (nonatomic, strong) UITextView *remindTV;
@end
