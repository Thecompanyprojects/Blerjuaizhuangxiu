//
//  CaseMaterialTwoModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaseMaterialTwoModel : NSObject
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString *jobType;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *browse;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *goodsNum;
@property (nonatomic, copy) NSString *agencysId;
@property (nonatomic, assign) NSInteger agencysIds;//添加人id

@property (nonatomic, strong) NSArray *commentList;
@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *materialConstructionId;
@property (nonatomic, copy) NSString *materialId;//本案主材id
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *merchantId;//店铺id

@property (nonatomic, copy) NSString *times;//企业VIP的标志
@property (nonatomic,copy) NSString *isLog;//日志vip的标志
//主材日志封面图
@property(nonatomic,copy)NSString *coverMap;

//小区名称
@property(nonatomic,copy)NSString *ccAreaName;
//工单编号
@property(nonatomic,copy)NSString *constructionNo;
//分享标题
@property(nonatomic,copy)NSString *shareTitle;
@end
