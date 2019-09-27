//
//  CertificateInformationViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "CertificationModel.h"

@interface CertificateInformationViewController : SNViewController
@property (nonatomic, strong) CertificationModel *model;
@property (nonatomic, copy) NSString *companyId;
@property (weak, nonatomic) IBOutlet UIView *timeView;

// 有timeview 值为50  没有值为0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTimeViewCon;


@end
