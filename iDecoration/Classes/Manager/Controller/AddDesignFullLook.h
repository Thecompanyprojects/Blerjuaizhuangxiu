//
//  AddDesignFullLook.h
//  iDecoration
//
//  Created by sty on 2017/9/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface AddDesignFullLook : SNViewController
@property (nonatomic, strong) NSString *coverImgStr;//全景封面
@property (nonatomic, strong) NSString *nameStr;//全景名称
@property (nonatomic, strong) NSString *linkUrl;//全景链接

@property (nonatomic, copy) void (^FullBlock)(NSString *coverImgStr,NSString *nameStr,NSString *linkUrl);
@end
