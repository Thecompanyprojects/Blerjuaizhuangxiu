//
//  recommendedModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface recommendedModel : NSObject
@property (nonatomic, copy) NSString *customizedVip;
@property (nonatomic, copy) NSString *companyType;
@property (nonatomic, copy) NSString *recommendVip;
@property (nonatomic, copy) NSString *disNum;
@property (nonatomic, copy) NSString *likeNum;
@property (nonatomic, copy) NSString *cancled;
@property (nonatomic, copy) NSString *relId;
@property (nonatomic, copy) NSString *Newid;
@property (nonatomic, copy) NSString *checked;
@property (nonatomic, copy) NSString *calVip;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imgs;
@property (nonatomic, copy) NSString *conVip;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *modified;
@property (nonatomic, copy) NSString *liked;
//@property (nonatomic, copy) NSString *Newid;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *appVip;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyId;

@property (nonatomic, copy) NSString *constructionType;

@property (nonatomic,assign) NSInteger authenticationId;//大于0 认证

@property (nonatomic, copy) NSString *attentionId;//0 未关注 1 已关注

@property (nonatomic , copy) NSString *options;
@property (nonatomic , assign) NSInteger activityPlace;
@end


