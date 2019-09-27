//
//  selectsitetagsVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/26.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "SNViewController.h"
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(NSMutableArray *)array;

@end
NS_ASSUME_NONNULL_BEGIN

@interface selectsitetagsVC : SNViewController
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end

NS_ASSUME_NONNULL_END
