//
//  draftboxModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface draftboxModel : NSObject
@property (nonatomic,copy) NSString *draftId;//草稿id
@property (nonatomic,copy) NSString *designsId;//转存美文id
@property (nonatomic,copy) NSString *draftContent;//草稿内容
@property (nonatomic,copy) NSString *addTime;//添加时间
@property (nonatomic,copy) NSString *agencysId;//添加人员id
@end
