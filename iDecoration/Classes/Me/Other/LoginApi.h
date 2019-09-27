//
//  LoginApi.h
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface LoginApi : YTKRequest

-(id)initWithPhone:(NSString*)phone flag:(NSString*)flag password:(NSString*)password;

@end
