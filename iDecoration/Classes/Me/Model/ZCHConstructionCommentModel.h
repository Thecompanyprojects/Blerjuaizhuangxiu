//
//  ZCHConstructionCommentModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHConstructionCommentModel : NSObject

/**
 *  职位名称
 */
@property (copy, nonatomic) NSString *JobTypeName;
// 获取评论内容的时候用这个
@property (copy, nonatomic) NSString *roleTypeName;
/**
 *  姓名
 */
@property (copy, nonatomic) NSString *trueName;
/**
 *  头像
 */
@property (copy, nonatomic) NSString *photo;
/**
 *  人员Id
 */
@property (copy, nonatomic) NSString *agencyId;
/**
 *  评论内容
 */
@property (copy, nonatomic) NSString *content;
/**
 *  评级
 */
@property (copy, nonatomic) NSString *grade;

@end
