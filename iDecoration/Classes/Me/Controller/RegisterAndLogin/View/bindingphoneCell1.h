//
//  bindingphoneCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLButtonCountdownManager.h"
#import "WLCaptcheButton.h"

@interface bindingphoneCell1 : UITableViewCell

typedef void(^bindingphoneCell1Block)(void);

@property (copy, nonatomic) bindingphoneCell1Block blockDidTouchButton;
@property (nonatomic,strong) UITextField *codeText;
@property (nonatomic,strong) WLCaptcheButton *setBtn;
@end
