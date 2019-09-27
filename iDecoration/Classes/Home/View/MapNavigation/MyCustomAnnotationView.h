//
//  MyCustomAnnotationView.h
//  MKMapPop
//
//  Created by zuxi li on 2017/9/15.
//  Copyright © 2017年 lizuxi. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CustomCalloutViewController.h"
@class MyCustomAnnotation;

@interface MyCustomAnnotationView : MKAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@property(strong,nonatomic)CustomCalloutViewController *calloutViewController;
@property(strong,nonatomic)MyCustomAnnotation *myCustomAnnotation;

@end
