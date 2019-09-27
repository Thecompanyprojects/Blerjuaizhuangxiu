//
//  SignContractViewController.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface SignContractViewController : SNViewController
@property (nonatomic, assign) NSInteger cJobTypeIdStr;
@property (nonatomic, assign) NSInteger constructionIdStr;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger isAdd;//第一次填写传0（没有数据的时候），else ：1
@property (nonatomic, assign) NSInteger index;//1:从施工日志进入  2:从主材日志进入

@property (nonatomic, copy) NSString *companyLogo; // 公司logo ，加水印使用
@property (nonatomic, copy) NSString *companyName;//公司名称，加水印使用
@property (nonatomic, copy) NSString *nodeId;//节点id

@property (nonatomic,copy) NSString *companyId;//公司ID

@property (nonatomic,copy) NSString *agencysJob;//公司职位id


@end
