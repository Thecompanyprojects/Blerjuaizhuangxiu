//
//  AdviserList.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdviserList : NSObject
@property (nonatomic , assign) NSInteger              adviserSax;
@property (nonatomic , copy) NSString              * adviserName;
@property (nonatomic , copy) NSString              * managerCity;
@property (nonatomic , copy) NSString              * adviserPhoto;
@property (nonatomic , copy) NSString              * adviserWx;
@property (nonatomic , assign) NSInteger              adviserId;
@property (nonatomic , copy) NSString              * adviserPhone;
@property (nonatomic , assign) NSInteger              adviserAge;
@property (nonatomic , copy) NSString              * adviserQq;
@property (nonatomic , assign) NSInteger              createDate;
@property (nonatomic , copy) NSString              * cityList;
@end
