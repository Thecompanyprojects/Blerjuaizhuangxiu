//
//  focusModel1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/31.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface focusModel1 : NSObject
@property (nonatomic,assign) NSInteger attentionId;
@property (nonatomic,assign) NSInteger companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, copy) NSString *companyNumber;
@property (nonatomic,assign) NSInteger headQuarters;
@property (nonatomic, copy) NSString *companyIntroduction;
@property (nonatomic, assign) NSInteger customized;
@property (nonatomic, assign) NSInteger messageNum;
@property (nonatomic, assign) NSInteger recommendVip;//推荐会员
@property (nonatomic, assign) NSInteger appVip;
@end
