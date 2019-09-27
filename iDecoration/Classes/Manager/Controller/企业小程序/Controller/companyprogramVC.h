//
//  companyprogramVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "SubsidiaryModel.h"
#import "YGLCurrentPersonCompanyModel.h"
@interface companyprogramVC : SNViewController
/**
 
 */
@property (strong, nonatomic) SubsidiaryModel *currentModel;
@property (nonatomic,strong) NSMutableArray *curremtModelArray;
@property (nonatomic, strong) NSMutableArray *currentPersonCompanyArray; // 当前人员具有的公司数组
@property (nonatomic, strong) YGLCurrentPersonCompanyModel *currentCompanyModel; // 当前选择的公司

@end
