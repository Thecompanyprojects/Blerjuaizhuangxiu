//
//  ConstructMemberAddController.h
//  iDecoration
//
//  Created by Apple on 2017/5/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConstructMemberAddController : UIViewController
@property (nonatomic, assign) NSInteger index; //1:工人，业主   2:默认员工
@property (nonatomic, assign) NSInteger jobId; //工人（1025），业主（1001）其他：普通员工
@property (nonatomic, copy) NSString *participanId;
@property (nonatomic, assign) NSInteger consID;

@property (nonatomic, assign) NSInteger fromIndex;//1:从施工日志进入  2:从主材日志进入

@property(nonatomic,copy)NSString *groupid;

@property(nonatomic,copy)NSString *huanxinID;

@property (nonatomic,copy) NSString *companyFlag;//1 公司  2 店铺
@end
