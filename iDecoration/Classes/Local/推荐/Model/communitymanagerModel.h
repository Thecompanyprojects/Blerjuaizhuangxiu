//
//  communitymanagerModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface communitymanagerModel : NSObject
@property (nonatomic , copy) NSString              * coveMap;
@property (nonatomic , copy) NSString              * mobelRoom;
@property (nonatomic , copy) NSString              * mobelNumber;
@property (nonatomic , assign) NSInteger              room;
@property (nonatomic , copy) NSString              * mobelAcreage;
@property (nonatomic , assign) NSInteger              communityId;
@property (nonatomic , assign) NSInteger              darawindRoom;
@property (nonatomic , assign) NSInteger              toilet;
@property (nonatomic , assign) NSInteger              mobelId;
@property (nonatomic , assign) NSInteger              createTime;
@property (nonatomic , assign) NSInteger              kitchen;

@end

NS_ASSUME_NONNULL_END
