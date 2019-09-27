//
//  MyCustomAnnotationView.m
//  MKMapPop
//
//  Created by zuxi li on 2017/9/15.
//  Copyright © 2017年 lizuxi. All rights reserved.
//

#import "MyCustomAnnotationView.h"
#import "MyCustomAnnotation.h"


@implementation MyCustomAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect myFrame = self.frame;
        myFrame.size.width = 20;
        myFrame.size.width = 20;
        self.frame = myFrame;
        
        self.opaque = NO;
        self.canShowCallout = NO;
        
        self.calloutViewController = [[CustomCalloutViewController alloc] initWithNibName:@"CustomCalloutViewController" bundle:nil];
        self.myCustomAnnotation = (MyCustomAnnotation *)annotation;
        YSNLog(@"%@", self.calloutViewController.view);
        UIView *calloutView = self.calloutViewController.view;
        
        self.calloutViewController.companyNametitle.text = self.myCustomAnnotation.companyName;
        self.calloutViewController.companyAddresstitle.text = self.myCustomAnnotation.companyAddress;
        
        calloutView.frame = CGRectMake(-96, -60, 213, 24);
        [self addSubview:calloutView];
        
    }
    return self;
}



- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                return isInside;
        }
    }
    return isInside;
}

































































@end
