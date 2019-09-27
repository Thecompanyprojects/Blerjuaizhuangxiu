//
//  addFullsenceViewController.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "senceModel.h"


@interface addFullsenceViewController : UIViewController

@property(nonatomic,copy)NSString *shopid;


@property(nonatomic,strong)senceModel *model;

@property (nonatomic, assign) NSInteger fromTag;//2000:工地的全景 默认0:公司的全景
@end
