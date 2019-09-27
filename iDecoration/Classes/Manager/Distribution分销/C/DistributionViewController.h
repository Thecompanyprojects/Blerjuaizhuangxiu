//
//  DistributionViewController.h
//  iDecoration
//
//  Created by 丁 on 2018/3/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface DistributionViewController : SNViewController

typedef enum{
    ENUM_ViewController895_ActionTypejiangli=0,
    ENUM_ViewController895_ActionTypeliaojie,
}ENUM_ViewController895_ActionType;

@property (nonatomic,assign) NSInteger InActionType; //操作类型
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *trueName;
@end
