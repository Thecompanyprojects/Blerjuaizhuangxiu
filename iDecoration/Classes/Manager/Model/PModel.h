//
//  PModel.h
//  iDecoration
//
//  Created by RealSeven on 17/3/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, strong) NSArray *cities;

@end
