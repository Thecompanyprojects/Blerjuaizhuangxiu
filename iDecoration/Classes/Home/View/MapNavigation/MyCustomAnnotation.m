//
//  MyCustomAnnotation.m
//  MKMapPop
//
//  Created by zuxi li on 2017/9/15.
//  Copyright © 2017年 lizuxi. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation
@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
        
    }
    return self;
}
@end
