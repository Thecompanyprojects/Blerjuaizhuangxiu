//
//  EditMuchUseController.h
//  iDecoration
//
//  Created by sty on 2017/10/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface EditMuchUseController : SNViewController
@property (nonatomic, strong) NSMutableArray *muchUseArray;
@property (nonatomic, assign) CGFloat keyBoardH;

@property (nonatomic, copy) void(^upLoadMuchUseBlock)(NSInteger updateType);

@property (nonatomic, copy) NSString *companyId;//公司id
@property (nonatomic, copy) NSString *type;//type 1 公司 0 个人
@property (nonatomic, copy) NSString *nodeId;//节点id

@property (nonatomic, copy) NSString *changyongyutype;//常用语类型

@property (nonatomic, copy) NSString *agencysJob;//职位id
@end
