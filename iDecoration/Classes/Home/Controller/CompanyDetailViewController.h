//
//  CompanyDetailViewController.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YellowPageNotVipButHaveActivleModel.h"
#import "HomeDefaultModel.h"



@interface CompanyDetailViewController : SNViewController
@property (nonatomic, strong)HomeDefaultModel *HomeModel;
@property (nonatomic, copy) NSString *companyID;
@property (nonatomic, copy) NSString *companyName;
//@property (assign, nonatomic) BOOL isImageCanClick;
// 公司logoURL
@property (nonatomic, strong) NSString *shareCompanyLogoURLStr;
// 分享出去的描述
@property (nonatomic, strong) NSString *shareDescription;
@property (nonatomic, strong) UIImage *companyLogo;

// 2: 表示点击合作企业进入的不可以再次进行跳转
@property (copy, nonatomic) NSString *times;

//@property (nonatomic, assign) VIPAndArticleType vipAndArticleTyple;

@property (nonatomic, assign) BOOL notVipButHaveArticle;
@property (nonatomic,copy) NSString *designsId;
- (CGSize)calculateImageSizeWithSize:(CGSize)size andType:(NSInteger)type;
- (CGSize)getImageSizeWithURL:(id)URL;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）

@property (nonatomic,copy) NSString *cityId;
@property (nonatomic,copy) NSString *countyId;
@end
