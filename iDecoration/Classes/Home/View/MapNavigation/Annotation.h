//
//  Annotation.h
//  iDecoration
//
//  Created by zuxi li on 2017/9/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

// 自定义一个图片属性在创建大头针视图时使用
@property (nonatomic, copy)NSString *imageName;
@end
