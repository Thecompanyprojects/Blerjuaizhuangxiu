//
//  JudgeIsRegistedApi.h
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface JudgeIsRegistedApi : YTKRequest

-(id)initWithPhoneNumber:(NSString*)phone;

@end
