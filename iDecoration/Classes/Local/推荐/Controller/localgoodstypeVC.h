//
//  localgoodstypeVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(NSString *)index;

@end
@interface localgoodstypeVC : SNViewController
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
