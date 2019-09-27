//
//  EventdetailsVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/3/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

#import "SignUpManageListModel.h"
typedef NS_ENUM(NSUInteger, Mytype) {
    Mytypecompany,
    Mytypemessage,
};

@interface EventdetailsVC : SNViewController
@property (nonatomic, assign) Mytype state;
@property (nonatomic,strong) SignUpManageListModel *smodel;

@end
