//
//  CompanyCertificationController.h
//  iDecoration
//
//  Created by zuxi li on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyCertificationController : UITableViewController
@property (nonatomic, copy) NSString *companyId;
@property (copy, nonatomic) void(^CertificatSuccessBlock)();
@property (nonatomic, assign) BOOL isfromlogin;
@end
