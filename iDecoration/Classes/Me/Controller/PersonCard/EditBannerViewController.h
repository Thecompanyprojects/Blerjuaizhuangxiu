//
//  EditBannerViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface EditBannerViewController : SNViewController
@property (nonatomic, strong) NSString *agencyId;
@property (nonatomic, assign) BOOL isSendToCompany;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, copy)void(^completionBlock)();
@end
