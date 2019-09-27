//
//  dockingModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dockingModel : NSObject
@property (nonatomic,copy) NSString *trueName;//对接人姓名
@property (nonatomic,copy) NSString *createCode;//唯一生成码
@property (nonatomic,copy) NSString *photo;//头像
@property (nonatomic,copy) NSString *agencyId;//对接人id

@property (nonatomic,assign) BOOL ischoose;
@end

