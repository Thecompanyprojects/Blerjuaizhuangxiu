//
//  zonecommentModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zonecommentModel : NSObject
@property (nonatomic , copy) NSString              * picUrl;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , assign) NSInteger              isDisplay;
@property (nonatomic , copy) NSString              *Newid;
@property (nonatomic , assign) NSInteger              isTop;
@property (nonatomic , copy) NSString               *addTime;
@property (nonatomic , assign) NSInteger              designsId;
@property (nonatomic , assign) NSInteger              agencysId;
@property (nonatomic , copy) NSString              * nickName;

@end
