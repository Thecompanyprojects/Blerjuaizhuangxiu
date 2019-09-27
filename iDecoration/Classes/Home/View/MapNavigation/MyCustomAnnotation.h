//
//  MyCustomAnnotation.h
//  MKMapPop
//
//  Created by zuxi li on 2017/9/15.
//  Copyright © 2017年 lizuxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *companyAddress;

// 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic, copy)NSString *imageName;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;



@end
