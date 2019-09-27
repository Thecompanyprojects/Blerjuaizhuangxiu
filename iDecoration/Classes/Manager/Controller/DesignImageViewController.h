//
//  DesignImageViewController.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface DesignImageViewController : SNViewController

@property (nonatomic, strong) NSArray *assetArray;
@property (nonatomic, assign) NSInteger consID;

@property (nonatomic, assign) BOOL isPower;
@property (nonatomic, assign) BOOL isComplate;//是否交工
@end
