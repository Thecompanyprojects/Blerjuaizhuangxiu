//
//  BLEJCalculatorPackageTemplateModel.h
//  iDecoration
//
//  Created by john wall on 2018/8/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BLEJPackageArticleDesignModel;
@interface BLEJCalculatorPackageTemplateModel : NSObject


@property(strong,nonatomic)NSMutableArray <BLEJPackageArticleDesignModel*> *designModel;
/**
 *  套餐id
 */
@property (assign, nonatomic) NSInteger packageId;
/**
 * 套餐名字
 */
@property (copy, nonatomic) NSString *packageName;
/**
 *
 */
@property (copy, nonatomic) NSString *type;
/**
 *
 */
@property (assign, nonatomic) NSInteger companyId;
@property (assign, nonatomic) NSInteger price;

@property (copy, nonatomic) NSString * unit;
@property (copy, nonatomic) NSString * cover;
@property (copy, nonatomic) NSString * displayPosition;

@property (copy, nonatomic) NSString * introuction;
@property (copy, nonatomic) NSString * picUrl;
@property (copy, nonatomic) NSString * picHref;
@property (copy, nonatomic) NSString * picTitle;
@property (copy, nonatomic) NSString * createDate;
@property (copy, nonatomic) NSString * updateDate;;
@property (copy, nonatomic) NSString * updateBy;
@property (copy, nonatomic) NSString * fee;


////判断 工地类型（0：施工日志，1：主材日志）
//@property (nonatomic,copy) NSString *constructionType;

@end
