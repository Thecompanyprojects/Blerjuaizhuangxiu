//
//  UnionInviteMessageModel.h
//  iDecoration
//
//  Created by sty on 2017/10/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnionInviteMessageModel : NSObject

// 联盟邀请
@property(nonatomic,copy)NSString *trueName;//邀请人姓名(申请人姓名)
@property(nonatomic,copy)NSString *companyName;//被邀请的公司名称(公司名称)
@property(nonatomic,copy)NSString *unionName;//邀请的联盟名称
@property(nonatomic,copy)NSString *invitationId;//邀请id
@property(nonatomic,copy)NSString *invitationStatus;//状态（0：未处理，1：同意，2：拒绝）
@property(nonatomic,copy)NSString *unionLogo;//联盟logo

// 联盟申请
@property(nonatomic,copy)NSString *unionApplyId;//申请id
@property(nonatomic,copy)NSString *unionNumber;//联盟编号
@property(nonatomic,copy)NSString *companyLogo;//公司logo
@property(nonatomic,copy)NSString *applyStatus;//申请状态（0：待审核，1：通过，2：不通过）

@end
