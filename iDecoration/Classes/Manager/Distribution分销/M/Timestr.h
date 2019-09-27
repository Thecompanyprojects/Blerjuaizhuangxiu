//
//  Timestr.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Timestr : NSObject
+(NSString *)datetime:(NSString *)datestr;

+(NSString *)newdatetime:(NSString *)datestr;

+(NSInteger )creatdatetime:(NSString  *)newdate;
@end
