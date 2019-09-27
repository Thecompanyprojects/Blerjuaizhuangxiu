//
//  YPProgressView.m
//  iDecoration
//
//  Created by Apple on 2017/6/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "YPProgressView.h"

@implementation YPProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(YPProgressView *)showHMProgressView:(UIView *)parentView :(CGFloat)viewHeight{
    YPProgressView *progressView=(YPProgressView *)[parentView viewWithTag:999];
    if (!progressView) {
        progressView=[[YPProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        progressView.tag=999;
        progressView.center=parentView.center;
        progressView.top=viewHeight+kSCREEN_WIDTH/2-25;
        progressView.backgroundColor=[UIColor clearColor];
        [parentView addSubview:progressView];
    }
    return progressView;
    
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    // 重新绘制
    // 在view上做一个重绘的标记，当下次屏幕刷新的时候，就会调用drawRect.
    [self setNeedsDisplay];
    if (_progress==1) {//加载完成时移除
        [self removeFromSuperview];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.拼接路径
    CGPoint center = CGPointMake(25, 25);
    CGFloat radius = 25 - 2;
    CGFloat startA = -M_PI_2;
    CGFloat endA = -M_PI_2 + _progress * M_PI * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetLineWidth(ctx, 4);
    // 3.把路径添加到上下文
    [[UIColor lightGrayColor] set];
    CGContextAddPath(ctx, path.CGPath);
    
    // 4.把上下文渲染到视图
    CGContextStrokePath(ctx);
    
}

@end
