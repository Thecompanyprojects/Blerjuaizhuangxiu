//
//  ShopUnionListModel.h
//  iDecoration
//
//  Created by sty on 2017/10/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopUnionListModel : NSObject
@property(nonatomic,copy)NSString *isLeader;
@property(nonatomic,copy)NSString *sjs;
@property(nonatomic,copy)NSString *gz;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *goodsNum; // 商品数量
@property(nonatomic,copy)NSString *companyLandline;
@property(nonatomic,copy)NSString *jl;
@property(nonatomic,copy)NSString *seeFlag;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *al;  // 已交工工地数量
@property(nonatomic,copy)NSString *companyLogo;
@property(nonatomic,copy)NSString *companyIntroduction;
@property(nonatomic,copy)NSString *companyId;
@property(nonatomic,copy)NSString *appVip;
@property(nonatomic,copy)NSString *companyType;
@property(nonatomic,assign)NSInteger companyUnionId;//公司和联盟关联id

@property (nonatomic, copy) NSString *displayNumber;  // 展现量
@property (nonatomic, copy) NSString *constructionTotal; // 未交工工地数量
@end
