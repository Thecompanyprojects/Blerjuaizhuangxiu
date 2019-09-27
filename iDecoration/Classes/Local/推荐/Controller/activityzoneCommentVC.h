//
//  activityzoneCommentVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/1.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "activityzoneModel.h"
#import "activityzoneCell1.h"
#import "activityzoneCell0.h"
#import "homenewsModel.h"

@interface activityzoneCommentVC : SNViewController
@property (nonatomic,strong) activityzoneModel *zoneModel;
@property (nonatomic,strong) homenewsModel *homeModel;
@property (nonatomic,assign) bool ishome;
@end
