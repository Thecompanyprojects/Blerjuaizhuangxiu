//
//  SpreadDropMenu.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "MYPresentedController.h"
//创建一个代理
@protocol myTabVdelegate <NSObject>

-(void)myTabVClick:(NSInteger )index;

@end
@interface SpreadDropMenu : MYPresentedController
@property(assign,nonatomic)id<myTabVdelegate>delegate;
@end
