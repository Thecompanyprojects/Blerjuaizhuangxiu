//
//  BLRJCalculatortempletModelAllCalculatorTypes.h
//  iDecoration
//
//  Created by john wall on 2018/8/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
//"deal": 0,
//"length": 0,
//"merchandId": 0,
//"needed": 1,
//"number": 0,
//"spec": "",
//"sumMoney": 0,
//"supplementId": 20309,
//"supplementName": "墙固地固",
//"supplementPrice": 3,
//"supplementTech": "原墙面顶面防止翻砂，返碱。 材料选用：1、墙面刷美巢牌墙固．           2、不含基层处理费。",
//"supplementUnit": "",
//"templeteId": 346,
//"templeteTypeNo": 2012,
//"width": 0
@interface BLRJCalculatortempletModelAllCalculatorTypes : NSObject

//模版id
@property (assign, nonatomic) NSInteger templeteId;
//类型码值
@property (assign, nonatomic) NSInteger templeteTypeNo;

@property (assign, nonatomic) NSInteger deal;

@property (assign, nonatomic) NSInteger merchandId;

@property (assign, nonatomic) BOOL needed;



/****/
@property (assign, nonatomic) NSInteger number;

@property (copy, nonatomic) NSString *spec;

@property (assign, nonatomic) NSInteger sumMoney;

@property (copy, nonatomic) NSString *supplementId;

@property (copy, nonatomic) NSString *supplementName;

@property (copy, nonatomic) NSString* supplementPrice;

@property (copy, nonatomic) NSString *supplementTech;

@property (copy, nonatomic) NSString *supplementUnit;



@property (assign, nonatomic) NSInteger width;

@property (assign, nonatomic) NSInteger length;

@end
