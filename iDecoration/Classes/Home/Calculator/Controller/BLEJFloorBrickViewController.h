//
//  BLEJFloorBrickViewController.h
//  iDecoration
//
//  Created by john wall on 2018/8/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLRJCalculatortempletModelAllCalculatorTypes.h"
typedef void(^RefreshBlockBrick)(NSDictionary *dictPass);
typedef NSString*(^stringBlock)(NSString *strcity,NSString *strname);
typedef NSInteger MyInteger;

@interface BLEJFloorBrickViewController : UIViewController
@property(assign,nonatomic) BOOL isFromLastController;
@property(assign,nonatomic) BOOL isClickplusBtn;
@property(assign,nonatomic) BOOL isLastRowSelected;
@property(strong,nonatomic)NSString *companyID;
@property(strong,nonatomic)NSString *Contrlollertitle;
@property(strong,nonatomic)NSString *calcaulatorType;
@property(assign,nonatomic)NSInteger section;
@property(strong,nonatomic)NSIndexPath *indexpath;
@property(copy,nonatomic)RefreshBlockBrick blockBrick;
@property(strong,nonatomic)BLRJCalculatortempletModelAllCalculatorTypes *model;
@end
