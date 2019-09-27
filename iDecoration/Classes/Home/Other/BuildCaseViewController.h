//
//  BuildCaseViewController.h
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildCaseViewController : SNViewController

@property (nonatomic, copy) NSString *companyId;
@property (assign, nonatomic) BOOL isCompany;

// 是否开通了云管理会员
@property (assign, nonatomic) BOOL isConVIP;

@end
