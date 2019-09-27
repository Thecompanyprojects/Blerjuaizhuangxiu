//
//  UIView+Frame.m
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

+ (instancetype)blej_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}


- (void)setBlej_height:(CGFloat)blej_height
{
    CGRect rect = self.frame;
    rect.size.height = blej_height;
    self.frame = rect;
}

- (CGFloat)blej_height
{
    return self.frame.size.height;
}

- (CGFloat)blej_width
{
    return self.frame.size.width;
}
- (void)setBlej_width:(CGFloat)blej_width
{
    CGRect rect = self.frame;
    rect.size.width = blej_width;
    self.frame = rect;
}

- (CGFloat)blej_x
{
    return self.frame.origin.x;
    
}

- (void)setBlej_x:(CGFloat)blej_x
{
    CGRect rect = self.frame;
    rect.origin.x = blej_x;
    self.frame = rect;
}

- (void)setBlej_y:(CGFloat)blej_y
{
    CGRect rect = self.frame;
    rect.origin.y = blej_y;
    self.frame = rect;
}

- (CGFloat)blej_y
{

    return self.frame.origin.y;
}

- (void)setBlej_centerX:(CGFloat)blej_centerX
{
    CGPoint center = self.center;
    center.x = blej_centerX;
    self.center = center;
}

- (CGFloat)blej_centerX
{
    return self.center.x;
}

- (void)setBlej_centerY:(CGFloat)blej_centerY
{
    CGPoint center = self.center;
    center.y = blej_centerY;
    self.center = center;
}

- (CGFloat)blej_centerY
{
    return self.center.y;
}
@end
