//
//  GetImageVerificationCode.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "GetImageVerificationCode.h"

static UIImageView *_imageView;
static NSString *_UUIDString;

@implementation GetImageVerificationCode

+ (NSString *)UUIDString {
    return _UUIDString;
}

+ (void)setImageVerificationCodeToImageView:(UIImageView *)imageView {
    _imageView = imageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCodeURL)];
    imageView.userInteractionEnabled = true;
    imageView.clipsToBounds = true;
    [imageView addGestureRecognizer:tap];
    [imageView sd_setImageWithURL:[GetImageVerificationCode getCodeURL]];
}

+ (NSURL *)getCodeURL {
    NSString *url = [BASEURL stringByAppendingString:tupianyanzhengma];
    NSString *UUID = [GetImageVerificationCode getUUID];
    NSString *imageURL = [NSString stringWithFormat:@"%@%@%@",url,@"?v=",UUID];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    return [NSURL URLWithString:imageURL];
}

+ (NSString *)getUUID {
    NSString *UUID = [NSUUID UUID].UUIDString;
    UUID = [UUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@",UUID);
    _UUIDString = UUID;
    return UUID;
}
@end
