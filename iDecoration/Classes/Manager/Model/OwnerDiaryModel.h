//
//  OwnerDiaryModel.h
//  iDecoration
//
//  Created by Apple on 2017/6/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerDiaryModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *constructionId;
@property (nonatomic, copy) NSString *logId;
@property (nonatomic, copy) NSString *agencysId;
@property (nonatomic, copy) NSArray *imgList;
@end
