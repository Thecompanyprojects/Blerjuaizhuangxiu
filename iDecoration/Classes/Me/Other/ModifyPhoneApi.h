//
//  ModifyPhoneApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ModifyPhoneApi : YTKRequest

-(id)initWithPhone:(NSString*)phone agencyId:(NSInteger)agencyId code:(NSInteger)code;

@end
