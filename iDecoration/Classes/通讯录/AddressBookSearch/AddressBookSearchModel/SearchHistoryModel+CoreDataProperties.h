//
//  SearchHistoryModel+CoreDataProperties.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//
//

#import "SearchHistoryModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryModel (CoreDataProperties)

+ (NSFetchRequest<SearchHistoryModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *searchTitle;
@property (nullable, nonatomic, copy) NSString *agencyId;

@end

NS_ASSUME_NONNULL_END
