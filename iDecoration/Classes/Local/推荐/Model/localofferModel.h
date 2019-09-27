//
//  localofferModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localofferModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, assign) NSInteger appVip;
@property (nonatomic, assign) NSInteger svip;
@property (nonatomic, copy) NSString *distince;
@property (nonatomic, copy) NSString *flowers;
@property (nonatomic, copy) NSString *banners;
@property (nonatomic, copy) NSString *companyIntroduction;
@property (nonatomic, copy) NSString *companySlogan;
//distince 距离  flowers 好评  banners信用
@end
