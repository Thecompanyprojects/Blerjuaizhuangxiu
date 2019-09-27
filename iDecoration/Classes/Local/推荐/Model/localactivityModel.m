//
//  localactivityModel.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localactivityModel.h"

@implementation localactivityModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"template"])
        self.Newtemplate = value;
}
@end
