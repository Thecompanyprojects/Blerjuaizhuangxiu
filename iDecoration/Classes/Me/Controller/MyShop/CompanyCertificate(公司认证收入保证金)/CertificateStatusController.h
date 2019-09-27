//
//  CertificateStatusController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertificationModel.h"

@interface CertificateStatusController : UITableViewController
@property (nonatomic, strong) CertificationModel *cModel;
@property (nonatomic, copy) NSString *companyId;
@end
