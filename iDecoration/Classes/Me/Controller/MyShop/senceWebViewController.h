//
//  senceWebViewController.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "senceModel.h"
@interface senceWebViewController : SNViewController

@property(nonatomic,strong)senceModel *model;
//@property(nonatomic,copy)NSString *url;

@property (nonatomic, assign) BOOL isFrom;//no:从全景展示进入。yes：从本案设计进入
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, strong) NSString *flowerNumber;
@property (nonatomic, strong) NSString *pennantnumber;

// 公司名称
@property (nonatomic, copy) NSString *companyName;
// 公司logo
@property (nonatomic, copy) NSString *companyLogo;

@property (nonatomic, assign) BOOL isguanggao;

@property (nonatomic,assign) BOOL isfromlocal;
@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic,copy) NSString *companyType;
@property (nonatomic,copy) NSString *constructionType;
@end
