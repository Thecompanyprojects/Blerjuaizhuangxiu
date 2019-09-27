//
//  UIView+RectCorner.h
//  sudoku-ios
//
//  Created by Jay on 16/9/5.
//  Copyright © 2016年 Go. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//layer.cornerRadius的性能 比layer.mask更高些
//拖慢帧率的原因其实都是Off-Screen Rendering（离屏渲染）的原因。
//离屏渲染是个好东西，但是频繁发生离屏渲染是非常耗时的。
/*
 * Off-Screen Rendering
 
 离屏渲染，指的是GPU在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作。由上面的一个结论视图和圆角的大小对帧率并没有什么卵影响，数量才是伤害的核心输出啊。可以知道离屏渲染耗时是发生在离屏这个动作上面，而不是渲染。为什么离屏这么耗时？原因主要有创建缓冲区和上下文切换。创建新的缓冲区代价都不算大，付出最大代价的是上下文切换。
 
 上下文切换
 
 上下文切换，不管是在GPU渲染过程中，还是一直所熟悉的进程切换，上下文切换在哪里都是一个相当耗时的操作。首先我要保存当前屏幕渲染环境，然后切换到一个新的绘制环境，申请绘制资源，初始化环境，然后开始一个绘制，绘制完毕后销毁这个绘制环境，如需要切换到On-Screen Rendering或者再开始一个新的离屏渲染重复之前的操作。 下图描述了一次mask的渲染操作。
 */

/*
那么如何应对这个问题呢？不要在滚动视图使用cornerRadius或者mask。如果你非要作死怎么办呢？那么这样也可以拯救你：

1 2	self.layer.shouldRasterize = YES;   
 self.layer.rasterizationScale = [UIScreen mainScreen].scale;
 */

/*
 总结
 
 实现圆角cornerRadius要比mask高效很多。
 
 Rasterize在大部分情况下极大减少GPU工作。在有空间的情况下，大部分情况下缓存总能帮到你，不是吗？
 
 后台预处理图片也能很简单帮上你很大的忙。
 */
@interface UIView (RectCorner)

- (void)setCornerOn:(UIRectCorner)corner cornerWidth:(CGFloat)cornerWidth;

- (void)setAllCorner:(CGFloat)corner andBorderWidht:(CGFloat)width andColor:(UIColor *)color;
@end
