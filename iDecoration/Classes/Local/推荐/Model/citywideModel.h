//
//  citywideModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface citywideModel : NSObject
@property (copy, nonatomic) NSString *trueName;
@property (nonatomic,copy) NSString *cancled;
@property (nonatomic,copy) NSString *checked;//（0:待审核,1:审核成功,2:拒绝）
@property (nonatomic,copy) NSString *companyId;//公司id
@property (copy, nonatomic) NSString *companyName;
@property (nonatomic,copy) NSString *content;//推荐展示的文字内容
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *disNum;
@property (nonatomic,copy) NSString *Newid;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *likeNum;
@property (nonatomic,copy) NSString *modified;
@property (nonatomic,copy) NSString *relId;
@property (nonatomic,copy) NSString *share;
@property (nonatomic,copy) NSString *type;//类型
@property (nonatomic,copy) NSString *reason;//被拒绝原因

@property (nonatomic,assign) BOOL isshow;
@end


