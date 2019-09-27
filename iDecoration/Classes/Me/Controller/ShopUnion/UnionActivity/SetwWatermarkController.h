//
//  SetwWatermarkController.h
//  iDecoration
//
//  Created by sty on 2017/11/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface SetwWatermarkController : SNViewController

@property (nonatomic, copy) void(^setWaterBlock)(NSMutableArray *dataArray, NSInteger a);
@property (nonatomic, strong) NSArray *imgArray;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *comanyLogoStr;//公司logo（需要从上一个页面传入）
@property (nonatomic, assign) NSInteger companyId;

@property (nonatomic, assign) NSInteger consID;
@property (nonatomic, assign) NSInteger unionId;

@property (nonatomic, assign) BOOL isDesiger;//当前用户是否是工地的设计师(或者经理和总经理)
@property (nonatomic, assign) BOOL isComplate;//是否交工

@property (nonatomic, assign) NSInteger fromTag; //1:新增本案设计 2:编辑本案设计(编辑联盟活动,编辑公司活动,编辑店长手记) 3:日志新增编辑节点 4:联盟活动 5:新增个人美文 6:新增公司活动 7:编辑个人美文。8:新增店长手记 9:编辑礼品

@property (nonatomic, assign) NSInteger editTag;//编辑本案设计(编辑联盟活动和个人美文的时候)的时候用（2:修改cell上的图片  3:插入图片  4:添加图片到最后）

@property (nonatomic, assign) NSInteger jobTag;//身份职位(公司活动需要)
@end
