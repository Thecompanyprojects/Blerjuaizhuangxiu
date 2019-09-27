//
//  GetImageVerificationCode.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetImageVerificationCode : NSObject
@property (copy, nonatomic, class) NSString *UUIDString;

+ (void)setImageVerificationCodeToImageView:(UIImageView *)imageView;
@end
