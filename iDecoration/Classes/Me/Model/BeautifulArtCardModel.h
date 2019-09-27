//
//  BeautifulArtCardModel.h
//  iDecoration
//
//  Created by sty on 2018/1/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeautifulArtCardModel : NSObject
@property (nonatomic, assign) NSInteger readNum;
//
@property (nonatomic, assign) NSInteger activityPerson;
//
@property (nonatomic, assign) NSInteger musicPlay;
//
//@property (nonatomic, copy) NSString *template;
//
@property (nonatomic, assign) NSInteger addTime;
//
@property (nonatomic, copy) NSString *coverMap;
//
@property (nonatomic, assign) NSInteger type;//2:个人 3:公司
//
@property (nonatomic, assign) NSInteger activityId;//0:不是活动

@property (nonatomic, copy) NSString *companyLandline;
@property (nonatomic, copy) NSString *companyPhone;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger companyId;
//
@property (nonatomic, copy) NSString *endTime;
//
@property (nonatomic, assign) NSInteger designsId;
//
@property (nonatomic, assign) NSInteger agencysId;
//
@property (nonatomic, copy) NSString *designTitle;
//

//
@property (nonatomic, assign) NSInteger order;
//
@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, assign) NSInteger isDisplay; //是否在名片展示0不展示1展示

@property (nonatomic, assign) NSInteger flag; //是否在展示0不展示1展示
//
@property (nonatomic, assign) NSInteger shareNumber;

@end
