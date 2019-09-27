//
//  UIView+Frame.h
//

#import <UIKit/UIKit.h>
/*
 
    写分类:避免跟其他开发者产生冲突,加前缀
 
 */
@interface UIView (Frame)

@property CGFloat blej_width;
@property CGFloat blej_height;
@property CGFloat blej_x;
@property CGFloat blej_y;
@property CGFloat blej_centerX;
@property CGFloat blej_centerY;

+ (instancetype)blej_viewFromXib;
@end
