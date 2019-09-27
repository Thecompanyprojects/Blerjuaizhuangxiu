//
//  FlowersListModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/18.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowersListModel : NSObject

/**
 赠送人员Id
 */
@property (copy, nonatomic) NSString *agencyId;
/**
 日期
 */
@property (copy, nonatomic) NSString *createDate;
/**
 鲜花Id
 */
@property (copy, nonatomic) NSString *flowerId;
/**
 接收人id
 */
@property (copy, nonatomic) NSString *personId;
/**
 头像
 */
@property (strong, nonatomic) NSURL *photo;
/**
 故事
 */
@property (copy, nonatomic) NSString *story;
/**
 标题
 */
@property (copy, nonatomic) NSString *title;
/**
 赠送人姓名
 */
@property (copy, nonatomic) NSString *trueName;
/**
 type 0普通 1 鲜花故事
 */
@property (assign, nonatomic) BOOL type;
@end
