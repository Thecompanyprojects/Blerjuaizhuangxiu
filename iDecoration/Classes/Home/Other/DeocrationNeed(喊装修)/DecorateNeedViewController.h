//
//  DecorateNeedViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface DecorateNeedViewController : SNViewController
@property(nonatomic,copy)NSString *companyID;

//装修区域
@property(nonatomic,strong)NSArray *areaList;

@property (nonatomic, strong) NSString *companyType; // 公司类型  1018  公司  默认      其他的是店铺
@end
