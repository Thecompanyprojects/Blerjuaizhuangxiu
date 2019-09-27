//
//  ExcellentCaseViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "InstructionsViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ExcellentCaseViewControllerType) {
    ExcellentCaseViewControllerTypeExcellentCase = 0,//优秀案例
    ExcellentCaseViewControllerTypeMiniProgram = 1,//小程序
    ExcellentCaseViewControllerTypePCManager = 2,//PC端管理
    ExcellentCaseViewControllerTypePublic = 3//公众号
};
@interface ExcellentCaseViewController : InstructionsViewController
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) enum ExcellentCaseViewControllerType controllerType;

@end

NS_ASSUME_NONNULL_END
