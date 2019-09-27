//
//  MapTool.h
//  iDecoration
//
//  Created by zuxi li on 2017/9/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class MapTool;
@interface MapTool : NSObject


+ (MapTool *)sharedMapTool;


/**
 调用三方导航

 @param coordinate 经纬度
 @param name 地图上显示的名字
 @param tager 当前控制器
 */
- (void)navigationActionWithCoordinate:(CLLocationCoordinate2D)coordinate WithENDName:(NSString *)name tager:(UIViewController *)tager;

@end
