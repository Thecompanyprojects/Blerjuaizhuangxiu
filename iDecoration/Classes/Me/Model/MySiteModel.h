//
//  MySiteModel.h
//  iDecoration
//
//  Created by Apple on 2017/6/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySiteModel : NSObject

@property (nonatomic, copy) NSString *ccConstructionNodeId;
@property (nonatomic, copy) NSString *constructionId;
@property (nonatomic, copy) NSString *ccComplete;//工地的完成状态标识0：新建，1：可以交工，2：已交工未评论，3：已评论
@property (nonatomic, copy) NSString *crRoleName;
@property (nonatomic, copy) NSString *ccSrartTime;
@property (nonatomic, copy) NSString *ccAreaName;
@property (nonatomic, copy) NSString *ccHouseholderName;
@property (nonatomic, copy) NSString *positionNumber;//当前的是否有去人交工的角色 >0则表示有(可以置顶 取消置顶 删除)
@property (nonatomic, copy) NSString *ccBuilder;
@property (nonatomic, copy) NSString *isProprietor;//是否为也只标识 >0则表示为业主
@property (nonatomic, copy) NSString *companyType;//工地公司类型1018为装修公司，其他为店铺
@property (copy, nonatomic) NSString *top;//是否推送 (0没有推送  >0 都是推送过的 日志)
@property (copy, nonatomic) NSString *isTop;//是否置顶 (0没有置顶  >0 都是置顶过的)
@property (copy, nonatomic) NSString *isAppVip;//企业网会员
@property (copy, nonatomic) NSString *isCalVip;//计算器会员
@property (copy, nonatomic) NSString *isConVip;//云管理会员
@property (copy, nonatomic) NSString *companyId;//公司ID
@property (copy, nonatomic) NSString *isYellow;//推送到企业(>0已经推送)
@property (copy, nonatomic) NSString *isDisplay;// 是否在企业网显示 (0: 不显示  1: 显示)
@property (nonatomic,copy)  NSString * recommend;//是否推送到同城
@property (nonatomic,copy)  NSString *constructionType;//0 施工日志  1 主材日志
@end
