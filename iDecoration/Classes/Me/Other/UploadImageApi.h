//
//  UploadImageApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface UploadImageApi : YTKRequest

-(id)initWithImgStr:(NSString*)imgStr type:(NSString*)type;

@end
