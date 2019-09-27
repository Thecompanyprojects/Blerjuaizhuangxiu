//
//  attentionModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface attentionModel : NSObject
@property (nonatomic, assign) NSInteger appVip;
@property (nonatomic, assign) NSInteger messageId;
@property (nonatomic, assign) NSInteger agencyId;
@property (nonatomic, assign) NSInteger relId;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger recommendVip;
@property (nonatomic, assign) NSInteger isRead;
@property (nonatomic, assign) NSInteger shareUm;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger readNum;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, assign) NSInteger infoId;
@property (nonatomic, copy) NSString *companyLogo;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, copy) NSString *picture1;
@property (nonatomic, copy) NSString *picture2;
@property (nonatomic, copy) NSString *picture3;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, copy) NSString *constructionType;
@end
