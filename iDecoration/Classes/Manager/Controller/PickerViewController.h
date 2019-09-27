//
//  PickerViewController.h
//  相册中多张图片的选择
//
//  Created by guyongfeng on 16/5/4.
//  Copyright © 2016年 GYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCommon.h"

@interface PickerViewController : UIViewController

@property(strong,nonatomic) void (^PhotoResult)(id responseObject);

@property(assign,nonatomic) NSInteger selectNum;

@property(strong,nonatomic) PHFetchResult *fetch;

@property(assign,nonatomic) ZZImageType imageType;

@end
