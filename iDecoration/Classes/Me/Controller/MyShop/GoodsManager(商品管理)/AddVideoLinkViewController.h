//
//  AddVideoLinkViewController.h
//  iDecoration
//
//  Created by zuxi li on 2018/1/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"

@interface AddVideoLinkViewController : SNViewController

@property (nonatomic, strong) NSString *coverImgStr;//视频封面
@property (nonatomic, strong) NSString *linkUrl;//视频链接
@property (nonatomic, strong) NSString *unionURL; // 通用链接

/**
 参数依次  图片链接 图片  视频链接 通用链接
 */
@property (nonatomic, copy) void (^AddLinkCompletionBlock)(NSString *coverImgStr, UIImage *coverImg,NSString *linkUrl, NSString *unionURL);

@end
