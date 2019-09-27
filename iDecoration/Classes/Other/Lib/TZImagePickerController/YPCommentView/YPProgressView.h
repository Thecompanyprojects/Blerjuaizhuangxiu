//
//  YPProgressView.h
//  iDecoration
//
//  Created by Apple on 2017/6/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPProgressView : UIView
@property (nonatomic, assign) CGFloat progress;

+(YPProgressView *)showHMProgressView:(UIView *)parentView :(CGFloat)viewHeight;
@end
