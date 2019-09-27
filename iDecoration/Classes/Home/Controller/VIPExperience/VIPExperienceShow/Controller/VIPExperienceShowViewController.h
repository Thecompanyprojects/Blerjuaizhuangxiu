//
//  VIPExperienceShowViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/27.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubsidiaryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPExperienceShowViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (assign, nonatomic) BOOL isEdit;

/**
 c公司ID
 */
@property (strong, nonatomic) NSString *companyId;

/**
 公司名称
 */
@property (strong, nonatomic) NSString *companyName;

/**

 */
@property (strong, nonatomic) SubsidiaryModel *modelSubsidiary;


/**
 来自注册页面
 */
@property (nonatomic,assign) BOOL isfromLogup;



@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）


@end

NS_ASSUME_NONNULL_END
