//
//  ZCHBudgetGuideConstructionCaseModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/15.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHBudgetGuideConstructionCaseModel : NSObject

/**
 *  工地id
 */
@property (copy, nonatomic) NSString *constructionId;
/**
 *  施工封面图，可能为空，返回空串(计算器的)
 */
@property (copy, nonatomic) NSString *picUrl;
/**
 *  小区名称
 */
@property (copy, nonatomic) NSString *ccAreaName;
/**
 *  施工单位
 */
@property (copy, nonatomic) NSString *ccBuilder;
/**
 *  分享标题
 */
@property (copy, nonatomic) NSString *ccShareTitle;
@property (copy, nonatomic) NSString *coverMap;

@property (copy, nonatomic) NSString *displayNumbers;

// 面积
@property (nonatomic, copy) NSString *ccAcreage;
// 装修风格
@property (nonatomic, copy) NSString *style;

//判断 工地类型（0：施工日志，1：主材日志）
@property (nonatomic,copy) NSString *constructionType;
@end
