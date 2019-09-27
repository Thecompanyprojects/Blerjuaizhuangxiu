//
//  UIView+RectCorner.m
//  sudoku-ios
//
//  Created by Jay on 16/9/5.
//  Copyright © 2016年 Go. All rights reserved.
//

#import "UIView+RectCorner.h"
//    CAShapLayer设置蒙版从而实现圆角
@implementation UIView (RectCorner)
- (void)setCornerOnTop {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setCornerOn:(UIRectCorner)corner cornerWidth:(CGFloat)cornerWidth {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(corner)
                                           cornerRadii:CGSizeMake(cornerWidth, cornerWidth)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setCornerOnBottom {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
- (void)setAllCorner {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                          cornerRadius:10.0];
//初始化CAShapeLayer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //设置shapeLayer路径和圆角弧度
    maskLayer.path = maskPath.CGPath;
    //设置ImageView的蒙版
    self.layer.mask = maskLayer;
//    然后这就完事了，但是这个方法主要占用的是GPU的资源，如果发现GPU本来占用资源就很高了，那么就不要用这个方法了。
}
- (void)setNoneCorner{
    self.layer.mask = nil;
}
//直接渲染图片
-(UIImage *)getImageRadius:(CGFloat)radius andImage:(UIImage *)image{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(c, path.CGPath);
    CGContextClip(c);
    [image drawInRect:rect];
    CGContextDrawPath(c, kCGPathFillStroke);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//设置圆角视图样式
-(void)setUpSelfView{
    //阴影 Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor; //黑
    self.layer.shadowOpacity = 0.33;//阴影的不透明度
    self.layer.shadowOffset = CGSizeMake(0, 1.5);//阴影的偏移
    self.layer.shadowRadius = 4.0;//阴影半径
    self.layer.shouldRasterize = YES; //圆角缓存
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;//栅格化图层 提高流畅度
    //圆角
    self.layer.cornerRadius = 10.0f;
}

//使用贝塞尔曲线绘制， 解决离屏渲染问题，推荐
//- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
//    
//    CGRect rect = (CGRect){0.f, 0.f, self.size};
//    UIGraphicsBeginImageContextWithOptions(self.size, NO, UIScreen.mainScreen.scale);
//    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
//    CGContextClip(UIGraphicsGetCurrentContext());
//    
//    [self drawInRect:rect];
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return image;
//}

- (void)setAllCorner:(CGFloat)corner andBorderWidht:(CGFloat)width andColor:(UIColor *)color {
    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                          cornerRadius:corner];
//    //初始化CAShapeLayer
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.bounds;
//    //设置shapeLayer路径和圆角弧度
//    maskLayer.path = maskPath.CGPath;
//    //设置ImageView的蒙版
//    self.layer.mask = maskLayer;
//    //    然后这就完事了，但是这个方法主要占用的是GPU的资源，如果发现GPU本来占用资源就很高了，那么就不要用这个方法了。
    
    self.layer.cornerRadius = corner;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}
@end
