//
//  CreatShopController.h
//  iDecoration
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubsidiaryModel;


typedef void(^CreatShopControllerBackRefresh)();

@interface CreatShopController : SNViewController
@property (nonatomic, strong) NSMutableArray *areaListArray;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isEdit;//是否是编辑
@property (assign, nonatomic) NSInteger type;

// 公司信息数据Model
@property (strong, nonatomic) SubsidiaryModel *model;
// 装修区域数组
@property (strong, nonatomic) NSMutableArray *renovateAreaArr;


@property (copy, nonatomic) CreatShopControllerBackRefresh refreshBlock;

@property (nonatomic, assign) NSInteger creatType;
@end
