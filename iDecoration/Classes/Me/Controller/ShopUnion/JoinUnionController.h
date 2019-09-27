//
//  JoinUnionController.h
//  iDecoration
//
//  Created by sty on 2017/10/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
#import "SearchUnionModel.h"

@interface JoinUnionController : SNViewController
@property (nonatomic, strong) SearchUnionModel *model;
@property(nonatomic,assign)NSInteger companyId;

@property(nonatomic,copy)NSString* companyName;
@end
