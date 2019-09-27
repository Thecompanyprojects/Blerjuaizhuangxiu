//
//  AreaListModel.h
//  iDecoration
//
//  Created by Apple on 2017/5/9.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaListModel : NSObject
@property (nonatomic, assign) NSInteger areaId;
@property (nonatomic, assign) NSInteger province;
@property (nonatomic, assign) NSInteger city;
@property (nonatomic, assign) NSInteger county;
@property (nonatomic, assign) NSInteger companyId;
@property (nonatomic, copy) NSString *retion;

@end
