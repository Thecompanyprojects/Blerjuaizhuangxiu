//
//  DecorationAreaViewController.h
//  iDecoration
//
//  Created by RealSeven on 17/2/21.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "RegionView.h"


typedef void(^ReturnRefereshBlcok)(NSArray *areaArr);
@interface DecorationAreaViewController : SNViewController

@property (nonatomic, strong) RegionView *regionView;

@property (nonatomic, strong) NSArray *listArray;
// 1: 表示是经理  总经理  进入可以进行编辑  2: 不可以进行编辑  nil 表示是创建公司或者编辑公司的时候不需要特殊处理
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) ReturnRefereshBlcok refreshBlock;

@property (nonatomic, assign) NSInteger index;  //1:从创建公司进入  2:从修改公司进入

-(void)setRegionViewShow;

@end
