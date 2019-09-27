//
//  CertificationPayController.h
//  iDecoration
//
//  Created by zuxi li on 2018/3/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^SuccessBlock)();

@interface CertificationPayController : UITableViewController
@property (nonatomic, copy) NSString *companyId;

/**
 上传需要的数据
 */
@property (strong, nonatomic) NSDictionary *dicData;
@property (copy, nonatomic) void(^successBlock)(void);
@end
