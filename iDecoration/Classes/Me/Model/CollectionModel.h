//
//  CollectionModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/8/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeBaseModel.h"
@interface CollectionModel : HomeBaseModel


// 公司id
@property (nonatomic, assign) NSInteger companyId;

//公司地址
@property (nonatomic, strong) NSString *companyAddress;
// 区县
@property (nonatomic, strong) NSString *address;
// 会员结束天数
@property (nonatomic, assign) NSInteger time;
//公司座机
@property (nonatomic, strong) NSString *companyLandLine;
// 设计师数量
@property (nonatomic, assign) NSInteger sjsNum;
// 工长数量
@property (nonatomic, assign) NSInteger gzNum;
// 案例数量
//@property (nonatomic, assign) NSInteger constructionNum;
// 浏览量
@property (nonatomic, assign) NSInteger brows;
// 监理数量
@property (nonatomic, assign) NSInteger jlNum;
// 公司Logo
@property (nonatomic, strong) NSString *companyLogo;
// 公司名称
@property (nonatomic, strong) NSString *companyName;


//  是否114可查（0：不可查看 1：可查看）
@property (nonatomic, assign) NSInteger seeFlag;
//店铺类型  1008 公司   非1008 店铺
@property (nonatomic, assign) NSInteger companyType;
//收藏id
@property (nonatomic, assign) NSInteger collectionId;
// 公司简介
@property (nonatomic, strong) NSString *companyIntroduction;

// 收藏量
@property (copy, nonatomic) NSString *collectionNumbers;


// 案例数  已交工工地数
@property (nonatomic, copy) NSString *caseTotal;
//未交工工地数量
@property (nonatomic, assign) NSInteger constructionNum;
//@property (nonatomic, copy) NSString *constructionNum;

// 商品数量
@property (nonatomic, assign) NSInteger goodsNum;

// 商家商品量
//@property (nonatomic, copy) NSString *goodsNum;
// 展现量
@property (copy, nonatomic) NSString *displayNumbers;
// 认证状态（0：未交认证费，1：待认证，2：已认证，3：认证失败，4：认证过期）
@property (nonatomic, copy) NSString *status;
// 1是0不是 钻石会员
@property (nonatomic, strong) NSString *recommendVip;

@property (nonatomic, copy) NSString *display;
@property (nonatomic, copy) NSString *faceImg;
@property (nonatomic, copy) NSString *isDisplay;

@property (nonatomic, copy) NSString *likeNumber;
@property (nonatomic, copy) NSString *merchantId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *scanCount;
@property (nonatomic, copy) NSString *shareNumbers;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *todayBrowse;
@property (nonatomic, copy) NSString *todayDisplay;
@property (nonatomic, copy) NSString *todayShare;



//工地
@property (nonatomic, copy) NSString *crRoleName;
@property (nonatomic, copy) NSString *ccShareTitle;
@property (nonatomic, copy) NSString *trueName;
//@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, copy) NSString *ccHouseholderName;
@property (nonatomic, copy) NSString *ccCrateTime;
@property (nonatomic, copy) NSString *ccConstructionName;
@property (nonatomic, copy) NSString *ccBuilder;
@property (nonatomic, copy) NSString *ccAcreage;
@property (nonatomic, assign) NSInteger constructionType;
@property (nonatomic, assign) NSInteger ccConstructionNodeId;
@property (nonatomic, copy) NSString *ccCompleteDate;
@property (nonatomic, copy) NSString *Newid;
@property (nonatomic, copy) NSString *ccAddress;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *ccCreateDate;
@property (nonatomic, assign) NSInteger ccHouseholderId;
@property (nonatomic, copy) NSString *ccComments;
@property (nonatomic, copy) NSString *ccAreaName;
@property (nonatomic, copy) NSString *ccSrartTime;
@property (nonatomic, assign) NSInteger ccComplete;
@property (nonatomic, copy) NSString *coverMap;

//美文


@property (nonatomic, assign) NSInteger today_share;
@property (nonatomic, assign) NSInteger isDel;
@property (nonatomic, copy) NSString *picTitle;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *readNum;
@property (nonatomic, copy) NSString *designTitle;
@property (nonatomic, assign) NSInteger designId;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *voteDescribe;


@property (nonatomic, copy) NSString *designSubtitle;
@property (nonatomic, copy) NSString *picHref;
@property (nonatomic, assign) NSInteger constructionId;
@property (nonatomic, assign) NSInteger share;
//@property (nonatomic, copy) NSString *photo;
@property (nonatomic, assign) NSInteger citywideRecommend;
@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, assign) NSInteger couponId;
//@property (nonatomic, copy) NSString *template;
//@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, assign) NSInteger voteType;
@property (nonatomic, copy) NSString *addTime;
//@property (nonatomic, assign) NSInteger collectionId;
@property (nonatomic, assign) NSInteger giftCouponId;
@property (nonatomic, assign) NSInteger isRecommend;
@property (nonatomic, assign) NSInteger agencysId;
@property (nonatomic, copy) NSString *likeNumbers;
@property (nonatomic, assign) NSInteger designsStatus;
@property (nonatomic, assign) NSInteger musicPlay;
@property (nonatomic, copy) NSString *musicName;

//名片
@property (nonatomic,copy) NSString *collectionTime;
//@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *companyJob;
@property (nonatomic,copy) NSString *personId;
@property (nonatomic,copy) NSString *cJobTypeName1;
@property (nonatomic,copy) NSString *cJobTypeName2;

@end
