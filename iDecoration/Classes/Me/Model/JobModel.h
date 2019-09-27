//
//  JobModel.h
//  iDecoration
//
//  Created by RealSeven on 17/2/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobModel : NSObject

@property (nonatomic, copy) NSString *cJobTypeClass;//父级职位编码
@property (nonatomic, assign) NSInteger cJobTypeId;//职位类型编码
@property (nonatomic, copy) NSString *cJobTypeName;//职位名称
@property (nonatomic, assign) NSInteger jobId;//职位编码id
@property (nonatomic, copy) NSString *whetherDel;//删除标识

@end
