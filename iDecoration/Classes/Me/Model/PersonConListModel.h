//
//  PersonConListModel.h
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonConListModel : NSObject

@property (nonatomic, copy) NSString *style;
//
@property (nonatomic, copy) NSString *likeNumber;
//
@property (nonatomic, copy) NSString *scanCount;

@property (nonatomic, copy) NSString *coverMap;
//
@property (nonatomic, copy) NSString *ccHouseholderName;
//
@property (nonatomic, copy) NSString *ccAcreage;

@property (nonatomic, copy) NSString *ccShareTitle;
//
@property (nonatomic, copy) NSString *displayNumbers;
//
@property (nonatomic, copy) NSString *companyType;
//
@property (nonatomic, assign) NSInteger constructionId;

@property (nonatomic, assign) NSInteger id;
//
@property (nonatomic, copy) NSString *isDisplay;
//
@property (nonatomic, copy) NSString *isConVip;

@property (nonatomic, copy) NSString *ccAreaName;
@end
