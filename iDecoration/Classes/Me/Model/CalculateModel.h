//
//  CalculateModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/6/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculateModel : NSObject

// 面积
@property (nonatomic, strong) NSString *floorArea;
// 户型
@property (nonatomic, strong) NSString *houseType;
// 房主电话
@property (nonatomic, strong) NSString *customerPhone;
// 公司名称
@property (nonatomic, strong) NSString *companyName;
// 创建时间
@property (nonatomic, strong) NSString *createDate;
// 花费
@property (nonatomic, strong) NSString *sumMoney;

// 客户ID ID 可能为空
@property (nonatomic, strong) NSString *customerId;

// 简装报价名称
@property (nonatomic, strong) NSString *simpleName;
// 简装报价总价
@property (nonatomic, strong) NSString *simpleSumoney;

// 精装报价名称
@property (nonatomic, strong) NSString *hardcoverName;
// 精装报价总价
@property (nonatomic, strong) NSString *hardcoverSumoney;

// 是否已读 1已读，0未读
@property (nonatomic, strong) NSString *isRead;
// 是否为星标 >0星标，0非星标
@property (nonatomic, strong) NSString *isStar;
// 备注
@property (nonatomic, copy) NSString *remark;
// 关联ID
@property (nonatomic, strong) NSString *customerManagerId;
// 业务员姓名
@property (nonatomic, strong) NSString *trueName;

// 是否是个人会员
@property (nonatomic, strong) NSString *personCalVip;
// 是否是公司会员
@property (nonatomic, strong) NSString *companyCalVip;

@property (nonatomic, strong) NSString *managerId;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *salseId;
@end
