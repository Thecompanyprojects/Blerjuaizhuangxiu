//
//  MainDiarySiteModel.h
//  iDecoration
//
//  Created by sty on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainDiarySiteModel : NSObject
@property (nonatomic, assign) NSInteger siteId;//工地id
@property (nonatomic, assign) NSInteger ccHouseholderId;//创建人id
@property (nonatomic, copy) NSString *ccHouseholderName;//户主名称
@property (nonatomic, copy) NSString *ccAddress;//地址
@property (nonatomic, copy) NSString *ccAreaName;//小区名称
@property (nonatomic, copy) NSString *ccCreateDate;//签约日期
@property (nonatomic, copy) NSString *ccCompleteDate;//竣工日期
@property (nonatomic, copy) NSString *ccCrateTime;//创建时间

@property (nonatomic, copy) NSString *companyName; // 公司名称
@property (nonatomic, copy) NSString *companyLogo; // 公司logo
@property (nonatomic, copy) NSString *companyAddess; // 公司地址
@property (nonatomic, copy) NSString *companyId; // 公司id
@property (nonatomic, copy) NSString *companyType; // 公司type
@property (nonatomic, copy) NSString *companyLandline; // 公司座机
@property (nonatomic, copy) NSString *companyPhone; // 公司手机号

@property (nonatomic, copy) NSString *ccSrartTime;//开工日期
@property (nonatomic, copy) NSString *ccShareTitle;//分享标题
@property (nonatomic, copy) NSString *province;//所属省
@property (nonatomic, copy) NSString *city;//所属市
@property (nonatomic, copy) NSString *area;//所属区县
@property (nonatomic, copy) NSString *ccConstructionNodeId;//当前施工节点
@property (nonatomic, copy) NSString *crRoleName;//当前施工节点名称（如果节点id为2000，则节点名称为“新日志”）
@property (nonatomic, assign) NSInteger ccComplete;//是否交工（0：不能交工，1：可交工, 2:已交工 3:已评论）
@property (nonatomic, strong) NSString *cpPersonId;// 0:不在工地。非0:在工地
@property (nonatomic, strong) NSString *cpLimitsId;// 工地的职位id

@property (nonatomic, copy) NSString *syDate;//剩余工期
@property (nonatomic, copy) NSString *yksDate;//已开工时间
@property (nonatomic, copy) NSString *ccAcreage;//面积
@property (nonatomic, copy) NSString *style;//风格

@property (nonatomic, copy) NSString *coverMap;//工地封面图

@property (nonatomic, copy) NSString *constructionNo;//工地编号
@property (nonatomic, copy) NSString *typeName;//类型名称
@property (nonatomic, copy) NSString *isExistence;//是否在工地


@property(nonatomic,copy)NSString *groupId;

@property (nonatomic,copy) NSString *label;//标签
@property(nonatomic,copy)NSString *implement;//是否是执行经理
@end
