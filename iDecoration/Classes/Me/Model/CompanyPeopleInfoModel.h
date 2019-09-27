//
//  CompanyPeopleInfoModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyPeopleInfoModel : NSObject
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *agencysName;
@property (nonatomic, copy) NSString *innerAndOuterSwitch;
@property (nonatomic, copy) NSString *agencysJob;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *jobName;
@property (nonatomic, copy) NSString *agencysId;
@property (nonatomic, assign)BOOL ischoose;
@property (nonatomic, copy) NSString *implement;//是否是执行经理
@end
