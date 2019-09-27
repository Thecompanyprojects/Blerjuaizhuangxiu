//
//  HistoryActivityViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryActivityViewController : SNViewController

@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger companyCalVip;//公司号码通vip的标示

@property(nonatomic,copy)NSString *companyLandLine;//座机号
@property(nonatomic,copy)NSString *companyPhone;//手机号

@end
