//
//  GetAllConstructionsApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface GetAllConstructionsApi : YTKRequest

-(id)initWithCcAreaName:(NSString*)ccAreaName agencyId:(NSInteger)agencyId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize;

@end
