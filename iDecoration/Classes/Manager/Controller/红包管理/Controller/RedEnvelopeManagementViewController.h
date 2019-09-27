//
//  RedEnvelopeManagementViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubsidiaryModel.h"
#import "YGLCurrentPersonCompanyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedEnvelopeManagementViewController : UIViewController

/**

 */
@property (strong, nonatomic) SubsidiaryModel *currentModel;
@property (nonatomic,strong) NSMutableArray *curremtModelArray;
@property (nonatomic, strong) NSMutableArray *currentPersonCompanyArray; // 当前人员具有的公司数组
@property (nonatomic, strong) YGLCurrentPersonCompanyModel *currentCompanyModel; // 当前选择的公司

@end

NS_ASSUME_NONNULL_END
