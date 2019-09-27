//
//  CreateCompanyApi.h
//  iDecoration
//
//  Created by RealSeven on 17/3/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface CreateCompanyApi : YTKRequest

-(id)initWithCreatePerson:(CGFloat)createPerson companyLogo:(NSString*)companyLogo companyName:(NSString*)companyName companyNumber:(NSString*)companyNumber companySlogan:(NSString*)companySlogan areaList:(NSString*)areaList agencysJob:(CGFloat)agencysJob headQuarters:(NSInteger)headQuarters;

@end
