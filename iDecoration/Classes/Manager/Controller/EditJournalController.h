//
//  EditJournalController.h
//  iDecoration
//
//  Created by Apple on 2017/5/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeModel.h"

@interface EditJournalController : UIViewController
@property (nonatomic, strong) NodeModel *model;
@property (nonatomic, strong) NSArray *imgList;//原始的imgUrl数组
@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *journalId;
@property (nonatomic, assign) NSInteger constructionId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *isAdd;
@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) NSInteger fromIndex; //1:施工日志 2:主材日志

@property (nonatomic, copy) NSString *companyLogo; // 公司logo ，加水印使用
@property (nonatomic, copy) NSString *companyName;//公司名称，加水印使用

@property (nonatomic, copy) NSString *companyId;

@property (nonatomic,copy) NSString *agencysJob;//公司职位id
@end
