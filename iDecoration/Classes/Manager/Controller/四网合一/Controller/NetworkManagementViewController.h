//
//  NetworkManagementViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/7/18.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubsidiaryModel.h"
#import "YGLCurrentPersonCompanyModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NetworkManagementViewController : UIViewController
@property (nonatomic, strong) SubsidiaryModel *currentModel; // 当前公司的model2
@property (nonatomic,strong) NSMutableArray *curremtModelArray;
@property (nonatomic, strong) NSMutableArray *currentPersonCompanyArray; // 当前人员具有的公司数组
@property (nonatomic, strong) YGLCurrentPersonCompanyModel *currentCompanyModel; // 当前选择的公司
@end

NS_ASSUME_NONNULL_END
