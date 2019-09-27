//
//  BELJDetailPackageController.h
//  iDecoration
//
//  Created by john wall on 2018/7/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "BLEJPackageArticleDesignModel.h"
#import "BLEJCalculatorPackageTemplateModel.h"
@interface BELJDetailPackageController : SNViewController

@property (nonatomic, copy) BLEJCalculatorPackageTemplateModel  *templateModel;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *dataArraysence;
@property (nonatomic, assign) BOOL isPackage699;//是否是699套餐
 @property (nonatomic, assign) BOOL   isFistr;//是否是第一次添加
@property (nonatomic, copy) NSString * introduction;//简介说明
@property (nonatomic, copy) NSString * price;//套餐单位单价
@property (nonatomic, copy) NSString * type;//0简装 1精装
@property (nonatomic, copy) NSString * companyId;//公司ID
@property (nonatomic, copy) NSString * agencyId;//公司职务id
@property (nonatomic, copy) NSString *coverImgStr;//全景封面
@property (nonatomic, copy) NSString *nameStr;//全景名称
@property (nonatomic, copy) NSString *linkUrl;//全景链接
//套餐的id
@property (copy, nonatomic) NSString *packageId699;
//套餐名字
@property (copy, nonatomic) NSString *packageName699;
//套餐的id
@property (copy, nonatomic) NSString *packageId999;
//套餐名字
@property (copy, nonatomic) NSString *packageName999;
@property (copy, nonatomic) NSString * companyIdConstant;
@property (nonatomic, strong) NSMutableArray *orialArray;//编辑时删除的cellModel的数组
@end
