//
//  RegisterApi.h
//  iDecoration
//
//  Created by RealSeven on 17/2/27.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface RegisterApi : YTKRequest

//-(id)initWithWxCode:(NSString *)wxCode phone:(NSString *)phone roleTypeId:(NSInteger)roleTypeId gender:(NSInteger)gender password:(NSString *)password trueName:(NSString *)trueName inviteCode:(NSString *)inviteCode;
-(id)initWithWxCode:(NSString *)wxCode phone:(NSString *)phone roleTypeId:(NSInteger)roleTypeId gender:(NSInteger)gender password:(NSString *)password trueName:(NSString *)trueName inviteCode:(NSString *)inviteCode andphoneCode:(NSString *)phoneCode;
@end
