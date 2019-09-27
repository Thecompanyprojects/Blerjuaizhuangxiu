//
//  UnionCompanyModel.h
//  iDecoration
//
//  Created by sty on 2017/10/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnionCompanyModel : NSObject
@property(nonatomic,assign)NSInteger constructionNum;
@property(nonatomic,assign)NSInteger times;
@property(nonatomic,assign)NSInteger companyType;
@property(nonatomic,assign)NSInteger companyId;
@property(nonatomic,copy)NSString *companyName;
@end
