//
//  communitymanagerVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "localcommunityModel.h"

@interface communitymanagerVC : SNViewController
@property (nonatomic,strong) localcommunityModel *comModel;
@property (nonatomic,assign) BOOL ischange;
@property (nonatomic,copy) NSString *companyId;
@end
