//
//  GetSiteListApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface GetSiteListApi : YTKRequest

-(id)initWithUserId:(NSInteger)userId ccHouseholderName:(NSString*)ccHouseholderName;

@end
