//
//  ZCHSimpleSettingRoomDetailModel.h
//  iDecoration
//
//  Created by 赵春浩 on 17/7/11.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCHSimpleSettingRoomDetailModel : NSObject

/**
 *  主键Id
 */
@property (copy, nonatomic) NSString *roomItemId;
/**
 *  精简装设置Id
 */
@property (copy, nonatomic) NSString *setId;
/**
 *  模板Id
 */
@property (copy, nonatomic) NSString *supplementId;
/**
 *  房间类型
 */
@property (copy, nonatomic) NSString *roomType;
/**
 *  公司Id
 */
@property (copy, nonatomic) NSString *companyId;
/**
 *  位置标识0：默认，1：棚面，2：墙面,3:地面
 */
@property (copy, nonatomic) NSString *positionType;
/**
 *  条目名称
 */
@property (copy, nonatomic) NSString *name;
/**
 * 添加数目
 */
@property (copy, nonatomic) NSString *itemNumber;
@end
