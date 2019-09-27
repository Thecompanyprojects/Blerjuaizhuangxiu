//
//  FeedBackApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface FeedBackApi : YTKRequest

/**
 放弃使用该方法使用下面的方法 接口多传了一个参数
 
 */
-(id)initWithPhone:(NSString*)phone content:(NSString*)content trueName:(NSString*)trueName;

-(id)initWithPhone:(NSString*)phone content:(NSString*)content trueName:(NSString*)trueName source:(NSString *)source;
@end
