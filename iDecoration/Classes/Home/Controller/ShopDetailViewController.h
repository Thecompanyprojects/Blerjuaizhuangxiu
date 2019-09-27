//
//  ShopDetailViewController.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YellowPageNotVipButHaveActivleModel.h"
#import "HomeDefaultModel.h"
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
@interface ShopDetailViewController : SNViewController

@property (nonatomic, copy) NSString *shopID;
@property (nonatomic, copy) NSString *shopName;
@property(nonatomic,strong)HomeDefaultModel *homeModel;
@property (nonatomic, strong) UIImage *shopLogo;

// 2: 表示点击合作企业进入的不可以再次进行跳转
@property (copy, nonatomic) NSString *times;

//@property (nonatomic, assign) VIPAndArticleType vipAndArticleTyple;

@property (nonatomic, assign) BOOL notVipButHaveArticle;
@property (nonatomic,copy) NSString *designsId;
@property (nonatomic,copy) NSString *origin;//数据来源（0首页,1同城2我的公司4小程序）
@end
