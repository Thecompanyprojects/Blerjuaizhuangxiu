//
//  ResetPwdApi.h
//  iDecoration
//
//  Created by RealSeven on 17/2/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ResetPwdApi : YTKRequest

-(id)initWithPhoneNumber:(NSString*)phone code:(NSString*)code newPwd:(NSString*)newPwd;


@end
