//
//  NewDesignImageController.h
//  iDecoration
//
//  Created by Apple on 2017/7/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "DesignCaseListModel.h"
#import "BLEJPackageArticleDesignModel.h"
@interface NewDesignImageController : SNViewController
@property (nonatomic, strong) NSArray *assetArray;
@property (nonatomic, assign) NSInteger consID;

@property (nonatomic, assign) NSInteger fromTag; //1:从本案设计设计进入 2:从活动进入 3:从美文进入 4:从礼品券进入
@property (nonatomic, assign) BOOL isPower;
@property (nonatomic, assign) BOOL isComplate;//是否交工
@property (nonatomic, assign) BOOL isDesignCaseListModel;//是否是DesignCaseListModel
@property (nonatomic, assign) NSInteger editOrAdd;//编辑还是新增。1:编辑 2:新增到前面 0:新增到最后一个
@property (nonatomic, strong) DesignCaseListModel *model;

@property (nonatomic, assign) NSInteger row;//插入到第几个前面

@property (nonatomic, copy) NSString *linkAddress;
@property (nonatomic, copy) NSString *linkDescrib;
@property (nonatomic, copy) NSString *myContructLink;//我的工地链接

@property (nonatomic, copy) NSString *nodeImgStr;//这个节点图片的url


@property (nonatomic, copy) NSString *companyId;//公司id
@property (nonatomic, copy) NSString *type;//判断选择公司还是个人  常用语模版使用


#pragma mark  BLEJPackageArticleDesignModel
@property (nonatomic, strong)BLEJPackageArticleDesignModel *artDesignModel;
@property (nonatomic, copy)NSString *designId;
@property (nonatomic, copy)NSString *packageId;

@end
