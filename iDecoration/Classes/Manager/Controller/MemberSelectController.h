//
//  MemberSelectController.h
//  iDecoration
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberSelectController : SNViewController

@property(nonatomic,copy)NSString *groupid; //群组ID
@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) NSInteger index;//1:从施工日志进入   2:从主材日志进入
@property (nonatomic,copy) NSString *companyFlag;//1 公司 2 店铺
@end
