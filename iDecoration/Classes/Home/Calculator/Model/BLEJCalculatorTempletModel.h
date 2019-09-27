//
//  BLEJCalculatorTempletModel.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/3.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEJCalculatorTempletModel : NSObject

// tech----------工艺  unit-----------单位
/**
 *  公司宣传
 */
@property (copy, nonatomic) NSString *companyAdvert;
/**
 *  公司展示(图片)
 */
@property (copy, nonatomic) NSString *companyDisplay;
/**
 *  公司Id
 */
@property (copy, nonatomic) NSString *companyId;
/**
 *  模板Id
 */
@property (copy, nonatomic) NSString *templetId;
/**
 *  公司logo
 */
@property (copy, nonatomic) NSString *companyLogo;
/**
 *  公司名称
 */
@property (copy, nonatomic) NSString *companyName;
/**
 *  创建日期
 */
@property (copy, nonatomic) NSString *createDate;
/**
 *  编辑时间
 */
@property (copy, nonatomic) NSString *modifyDate;
/**
 *  编辑人员
 */
@property (copy, nonatomic) NSString *modifyPersonId;

/**
*   商家说明
*/
@property (copy, nonatomic) NSString *introuction;

 /**
*  展现量
*/
@property (nonatomic, copy) NSString *displayNumbers;

/**
*  是否推荐到同城
*/
@property (nonatomic, copy) NSString *recommend;

/**
*  vip标识（是否开通统计计算器时间非0开通）
*/
@property (copy, nonatomic) NSString *calVipFlag;
 /**
*  会员结束时间(没有开通的话就是空串)
*/
@property (copy, nonatomic) NSString *endTime;
/**
 *   计算器模板状态0：老模板，1：新模板，2：完成简装或精装设置
 */
@property (copy, nonatomic) NSString *templetStatus;






/*******************************ItemModel*******************************************/

/**
 *  基础处理
 */
@property (copy, nonatomic) NSString *baseDeal;

@property (copy, nonatomic) NSString *baseDealTech;

@property (copy, nonatomic) NSString *baseDealUnit;

/**
 *  设计费
 */
@property (copy, nonatomic) NSString *design;

@property (copy, nonatomic) NSString *designTech;

@property (copy, nonatomic) NSString *designUnit;
/**
 *  电路改造
 */
@property (copy, nonatomic) NSString *electic;

@property (copy, nonatomic) NSString *electicTech;

@property (copy, nonatomic) NSString *electicUnit;
/**
 *  垃圾清运
 */
@property (copy, nonatomic) NSString *garbage;

@property (copy, nonatomic) NSString *garbageTech;

@property (copy, nonatomic) NSString *garbageUnit;
/**
 *  材料水平运输
 */
@property (copy, nonatomic) NSString *horizontal;

@property (copy, nonatomic) NSString *horizontalTech;

@property (copy, nonatomic) NSString *horizontalUnit;
/**
 *  乳胶漆施工
 */
@property (copy, nonatomic) NSString *latex;

@property (copy, nonatomic) NSString *latexTech;

@property (copy, nonatomic) NSString *latexUnit;
/**
 *  工程管理费
 */
@property (copy, nonatomic) NSString *management;

@property (copy, nonatomic) NSString *managementTech;

@property (copy, nonatomic) NSString *managementUnit;

/**
 *  包管道
 */
@property (copy, nonatomic) NSString *packetPipe;

@property (copy, nonatomic) NSString *packetPipeTech;

@property (copy, nonatomic) NSString *packetPipeUnit;
/**
 *  地砖铺贴
 */
@property (copy, nonatomic) NSString *pavingTile;

@property (copy, nonatomic) NSString *pavingTileTech;

@property (copy, nonatomic) NSString *pavingTileUnit;
/**
 *  石膏板吊平顶
 */
@property (copy, nonatomic) NSString *plasterboard;

@property (copy, nonatomic) NSString *plasterboardTech;

@property (copy, nonatomic) NSString *plasterboardUnit;
/**
 *  墙固地固
 */
@property (copy, nonatomic) NSString *solidWall;

@property (copy, nonatomic) NSString *solidWallTech;

@property (copy, nonatomic) NSString *solidWallUnit;

/**
 *  材料垂直运输
 */
@property (copy, nonatomic) NSString *vertical;

@property (copy, nonatomic) NSString *verticalTech;

@property (copy, nonatomic) NSString *verticalUnit;
/**
 *  墙砖铺设
 */
@property (copy, nonatomic) NSString *wallTiles;

@property (copy, nonatomic) NSString *wallTilesTech;

@property (copy, nonatomic) NSString *wallTilesUnit;
/**
 *  水路改造
 */
@property (copy, nonatomic) NSString *waterLine;

@property (copy, nonatomic) NSString *waterLineTech;

@property (copy, nonatomic) NSString *waterLineUnit;
/**
 *  防水
 */
@property (copy, nonatomic) NSString *waterproof;

@property (copy, nonatomic) NSString *waterproofTech;

@property (copy, nonatomic) NSString *waterproofUnit;






@end
