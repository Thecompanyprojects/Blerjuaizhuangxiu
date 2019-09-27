//
//  CollectionCompanyTool.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/17.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionCompanyTool : NSObject



/**
  收藏公司或店铺

 @param companyId companyId 公司id
 @param completionBlock 成功回调
 */
+ (void)saveShopOrCompanyWithCompanyID:(NSInteger)companyId completion:(void (^)(NSInteger collectionId, BOOL isSuccess))completionBlock;;


/**
 取消收藏公司

 @param collectionId 收藏的id
 @param completionBlock 取消收藏成功 返回收藏id和 是否成功
 */
+ (void)unCollectionShopOrCompanyWithCollectionID:(NSInteger)collectionId completion:(void (^)(NSInteger collectionId, BOOL isSuccess))completionBlock;


@end
