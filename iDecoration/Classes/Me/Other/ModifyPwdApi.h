//
//  ModifyPwdApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ModifyPwdApi : YTKRequest

-(id)initWithPhone:(NSString*)phone oldPwd:(NSString*)oldPwd newPwd:(NSString*)newPwd;

@end
