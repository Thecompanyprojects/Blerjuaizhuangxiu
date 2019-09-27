//
//  newdesignModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newdesignModel : NSObject
@property (nonatomic , assign) NSInteger              constructionId;
@property (nonatomic , assign) NSInteger              companyId;
@property (nonatomic , assign) NSInteger              musicPlay;
@property (nonatomic , assign) NSInteger              couponId;
@property (nonatomic , assign) NSInteger              giftCouponId;
@property (nonatomic , copy) NSString              * coverMap;
@property (nonatomic , assign) NSInteger              likeNum;
@property (nonatomic , assign) NSInteger              share;
@property (nonatomic , copy) NSString              * Newtemplate;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , assign) NSInteger              isDel;
@property (nonatomic , assign) NSInteger              likeNumbers;
@property (nonatomic , copy) NSString              * designTitle;
@property (nonatomic , assign) NSInteger              addTime;
@property (nonatomic , copy) NSString              * companyLogo;
@property (nonatomic , copy) NSString              * companyName;
@property (nonatomic , copy) NSArray<NSString *>              * imgUrl;
@property (nonatomic , assign) NSInteger              isRecommend;
@property (nonatomic , assign) NSInteger              designsStatus;
@property (nonatomic , assign) NSInteger              designId;
@property (nonatomic , assign) NSInteger              order;
@property (nonatomic , assign) NSInteger              readNum;
@property (nonatomic , copy) NSString *              companyLandline;
@property (nonatomic , copy) NSString *              companyPhone;
//@property (nonatomic , copy)   NSString            * addTime;
//@property (nonatomic , copy)   NSString            * readNum;
@property (nonatomic , assign) BOOL isliked;


@end
