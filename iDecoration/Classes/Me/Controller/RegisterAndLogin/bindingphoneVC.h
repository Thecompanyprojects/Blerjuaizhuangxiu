//
//  bindingphoneVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"



@interface bindingphoneVC : SNViewController

//定义枚举类型
typedef enum {
    ENUM_ViewControllerweixin=0,//开始
    ENUM_ViewControllerqq
} ENUM_ViewController895_ActionType;

@property (nonatomic,assign) NSInteger InActionType; //操作类型
@property (nonatomic,copy)   NSString *wxToken;
@property (nonatomic,copy)   NSString *qqToken;
@property (nonatomic,copy)   NSString *qqOpenId;
@end
