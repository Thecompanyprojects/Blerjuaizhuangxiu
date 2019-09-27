//
//  ZCHSimpleSettingRoomModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZCHSimpleSettingRoomDetailModel.h"

@interface ZCHSimpleSettingRoomModel : NSObject

/**
 *  类型
 */
@property (copy, nonatomic) NSString *typeNo;
/**
 *  名称
 */
@property (copy, nonatomic) NSString *name;
/**
 *  条目
 */
@property (strong, nonatomic) NSMutableArray <ZCHSimpleSettingRoomDetailModel *>*items;

@end
