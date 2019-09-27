//
//  ZCHCooperateListModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/10/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHCooperateListModel : NSObject


//appVip = 1;
//browse = 108;
//collectionNumbers = 0;
//companyAddress = "\U4e1c\U57ce\U533a";
//companyId = 1501;
//companyLandline = "010-3366369";
//companyLogo = "http://testimage.bilinerju.com/group1/M00/00/2C/rBHg0Fn68v2AUirqAAJsTNYR4QI117.jpg";
//companyName = "\U6211\U5f97\U5230";
//companyType = 1001;
//constructionTotal = 0;
//displayNumbers = 7884;
//merchandiesCount = 2;
//seeFlag = 0;
//typeName = "\U8f6f\U88c5\U914d\U9970";

//appVip = 1;
//cityName = "\U4e1c\U57ce\U533a";
//companyAddress = "\U5317\U4eac\U5e02-\U4e1c\U57ce\U533a \U55ef\U54ea38\U53f7";
//companyId = 1334;
//companyLogo = "http://testimage.bilinerju.com/group1/M00/00/1D/rBHg0FntynqAHkQ8AAHly9443gw305.jpg";
//companyName = "\U6bc5\U817e\U88c5\U4f01\U914d\U5957";
//constructionNum = 1;
//displayNumber = 22571;
//typeName = "\U4e94\U91d1\U5efa\U6750";



// 申请Id
@property (nonatomic, copy) NSString *applyID;
// 企业id
@property (nonatomic, copy) NSString *companyId;
// 企业名字
@property (nonatomic, copy) NSString *companyName;
// 设计师统计
@property (nonatomic, copy) NSString *designerTotal;
// 浏览数
@property (nonatomic, copy) NSString *browse;
// logo
@property (nonatomic, copy) NSString *companyLogo;
// 是否开通vip (1表示开通)
@property (nonatomic, copy) NSString *appVip;
// 工长统计
@property (nonatomic, copy) NSString *foremanTotal;
// 监理统计
@property (nonatomic, copy) NSString *supervisorTotal;
// 1018: 表示公司  其他: 表示店铺
@property (nonatomic, copy) NSString *companyType;
// 名称
@property (nonatomic, copy) NSString *typeName;

// 好评数
//@property (nonatomic, copy) NSString *praiseTotal;
// 区县信息
@property (nonatomic, copy) NSString *companyAddress;

// 公司简介
//@property (nonatomic, copy) NSString *companyIntroduction;

// 收藏的店铺或公司ID     collectionId    已收藏 > 0 ，  未收藏0   collectionId
//@property (nonatomic, assign) NSInteger collectionId;
// 位置信息
//@property (copy, nonatomic) NSString *locationStr;

// 收藏量
@property (copy, nonatomic) NSString *collectionNumbers;
// 申请状态
@property (copy, nonatomic) NSString *applyStatus;
// 电话(座机)
@property (copy, nonatomic) NSString *companyLandline;
// 是否是114可查
@property (nonatomic, copy) NSString *seeFlag;
// 合作企业logo
@property (copy, nonatomic) NSString *sloganLogo;
// 被申请公司id（处理人公司id, 用于消息）
@property (copy, nonatomic) NSString *applyCompanyId;
// 被申请公司名字（处理人公司名字）
@property (copy, nonatomic) NSString *benCompanyName;



// (添加联盟企业用的) 工地数
@property (copy, nonatomic) NSString *constructionNum;
// 展现量
@property (copy, nonatomic) NSString *displayNumber;
// 区县
@property (copy, nonatomic) NSString *cityName;

// 案例数  已交工工地数
@property (nonatomic, copy) NSString *caseTotla;
//未交工工地数量
@property (nonatomic, copy) NSString *constructionTotal;
// 商家商品量
@property (nonatomic, copy) NSString *merchandiesCount;
// 展现量
@property (copy, nonatomic) NSString *displayNumbers;
// 认证状态（0：未交认证费，1：待认证，2：已认证，3：认证失败，4：认证过期）
@property (nonatomic, copy) NSString *status;
// 1是0不是 钻石会员
@property (nonatomic, strong) NSString *recommendVip;

@end
