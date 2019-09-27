//
//  EditTextViewController.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface EditTextViewController : SNViewController
@property (nonatomic, assign) BOOL isMoreExplain; //是否是补充说明
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^completeBlock)(NSString *text);
@end
