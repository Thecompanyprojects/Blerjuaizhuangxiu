//
//  ComplainListApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface ComplainListApi : YTKRequest

-(id)initWithAgencyId:(NSInteger)agencyId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize;

@end
