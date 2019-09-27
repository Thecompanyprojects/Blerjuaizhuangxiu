//
//  OwnerEvaluateModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerEvaluateModel : NSObject
@property (nonatomic, copy) NSString * shareTitle;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString *frontPage;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSString * sumGrade;
@property (nonatomic, copy) NSString * photo;
@property (copy, nonatomic) NSString *constructionId;
@property (nonatomic,copy) NSString *constructionType;//判断工地类型 （0：施工日志，1：主材日志）
@end
