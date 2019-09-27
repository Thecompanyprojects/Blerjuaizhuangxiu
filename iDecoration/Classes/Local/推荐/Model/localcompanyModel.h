//
//  localcompanyModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localcompanyModel : NSObject
@property (nonatomic, assign) NSInteger appVip;
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *locationStr;
@property (nonatomic, assign) NSInteger seeFlag;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, assign) NSInteger caseTotal;
@property (nonatomic, assign) NSInteger displayNumbers;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, assign) NSInteger constructionTotal;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, copy) NSString *authenticationId;// 0 未认证 1 已认证
@property (nonatomic, copy) NSString *companyIntroduction;
@property (nonatomic, assign) NSInteger svip;

@end
