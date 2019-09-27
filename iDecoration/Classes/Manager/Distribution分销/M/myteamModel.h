//
//  myteamModel.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myteamModel : NSObject

//联系人数据
@property(nonatomic,strong)NSMutableArray *items;
//大小(分组中有多少项)
@property (nonatomic, readonly) NSUInteger size;
//是否折叠
@property (nonatomic, assign, getter=isFolded) BOOL folded;

//初始化方法

- (instancetype) initWithItem:(NSMutableArray *)item andphone:(NSMutableArray *)phone andleave:(NSMutableArray *)leave andcheckStatusarr:(NSMutableArray *)checkStatus andagencyidarr:(NSMutableArray *)agencyidarr andisChange:(NSMutableArray *)isChangearr andisThreeLevelarr:(NSMutableArray *)isThreeLevelarr andcreateCodearr:(NSMutableArray *)createCodearr;

//联系人头像
@property (nonatomic,strong) NSMutableArray *phonearr;
//联系人状态
@property (nonatomic,strong) NSMutableArray *isLevelarr;
//checkStatus// 申请状态
@property (nonatomic,strong) NSMutableArray *checkStatusarr;
//agencyid
@property (nonatomic,strong) NSMutableArray *agencyidarr;
//isChange
@property (nonatomic,strong) NSMutableArray *isChangearr;
//isThreeLevel
@property (nonatomic,strong) NSMutableArray *isThreeLevelarr;
//createCode
@property (nonatomic,strong) NSMutableArray *createCodearr;
@end
