//
//  optimalgoodsModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface optimalgoodsModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *standard;
@property (nonatomic, assign) NSInteger companyType;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) NSInteger isCheap;
@property (nonatomic, assign) NSInteger likeNumber;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) NSInteger scanCount;
@property (nonatomic, assign) NSInteger merchantId;
@property (nonatomic, copy) NSString *Newid;
@property (nonatomic, assign) NSInteger isDisplay;
@property (nonatomic, assign) NSInteger isSpread;
@property (nonatomic, copy) NSString *faceImg;
@property (nonatomic, assign) NSInteger createDate;
@property (nonatomic, strong) NSDictionary *activityList;//活动
@end



