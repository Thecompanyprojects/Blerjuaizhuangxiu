//
//  activityzoneModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activityzoneModel : NSObject
@property (nonatomic , copy) NSString              * money;
@property (nonatomic , assign) NSInteger              musicPlay;
@property (nonatomic , copy) NSString              * coverMap;
@property (nonatomic , assign) NSInteger              shareCount;
@property (nonatomic , copy) NSString              * designSubtitle;
@property (nonatomic , assign) NSInteger              companyId;
@property (nonatomic , copy) NSString              * companyAddress;
@property (nonatomic , assign) NSInteger              activityId;
@property (nonatomic , copy) NSString              * companyLandLine;
@property (nonatomic , copy) NSString              * templatePic;
@property (nonatomic , copy) NSString              * companyPhone;
@property (nonatomic , copy) NSString              * activityDistance;
@property (nonatomic , copy) NSString              * designTitle;
@property (nonatomic , copy) NSString              * activityAddress;
@property (nonatomic , copy) NSString              * companyLogo;
@property (nonatomic , copy) NSString              * companyName;
@property (nonatomic , assign) NSInteger              commentCount;
@property (nonatomic , assign) NSInteger              activityStatus;
@property (nonatomic , assign) NSInteger              designsId;
@property (nonatomic , assign) NSInteger              likeCount;
@property (nonatomic , assign) NSInteger              startTime;
@property (nonatomic , assign) NSInteger              order;

@property (nonatomic, assign) BOOL isliked;
@end
