//
//  DesignTeamDetailModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/4.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesignTeamDetailModel : NSObject
@property (nonatomic, copy) NSString * trueName;
@property (nonatomic, copy) NSString * photo;
@property (nonatomic, copy) NSString *agencyId;
@property (nonatomic, copy) NSString *proprietorId;
@property (nonatomic, copy) NSString *ccAreaName;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, copy) NSString * cdPicture;
@property (nonatomic, copy) NSString * roleTypeName;
@property (nonatomic, copy) NSString *ccShareTitle;
@property (nonatomic, copy) NSString * evaluateId;
@property (nonatomic, copy) NSString * constructionId;
@property (nonatomic, copy) NSString * grade;
@property (nonatomic, copy) NSString * companyId;
@property (nonatomic, copy) NSString * content;
@property (copy, nonatomic) NSString *companyType;

// 云管理会员
@property (copy, nonatomic) NSString *conVip;
@property (nonatomic,copy) NSString *constructionType;
@end
