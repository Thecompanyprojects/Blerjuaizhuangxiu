//
//  BannerListModel.h
//  iDecoration
//
//  Created by zuxi li on 2018/4/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//


// 锦旗列表的model 锦旗详情也可以用这个model
#import <Foundation/Foundation.h>

@interface BannerListModel : NSObject

@property (nonatomic, copy) NSString *agencyId; // 赠送人id
@property (nonatomic, copy) NSString *createTime; // 创建时间
@property (nonatomic, copy) NSString *bannerId; // id
@property (nonatomic, copy) NSString *leaveWord; // 留言
@property (nonatomic, copy) NSString *modified; // 支付时间
@property (nonatomic, copy) NSString *personId; // 接收人Id
@property (nonatomic, copy) NSString *photo; // 头像
@property (nonatomic, copy) NSString *receName; // 赠名
@property (nonatomic, copy) NSString *signName; // 署名
@property (nonatomic, copy) NSString *story; // 故事
@property (nonatomic, copy) NSString *trueName; // 真实姓名
/*
 大锦旗：1000 ~ 1005 六个
 小锦旗： 2000 ~   
 */
@property (nonatomic, copy) NSString *type; // 类型
@property (nonatomic, copy) NSString *content; // 内容

@end
