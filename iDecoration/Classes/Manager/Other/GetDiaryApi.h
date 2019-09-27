//
//  GetDiaryApi.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/26.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface GetDiaryApi : YTKRequest

-(id)initWithConstructionId:(NSInteger)constructionId agencysId:(NSInteger)agencysId;

@end
