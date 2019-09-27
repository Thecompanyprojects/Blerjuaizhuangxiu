//
//  SearchHistoryModel+CoreDataProperties.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/28.
//  Copyright © 2018年 RealSeven. All rights reserved.
//
//

#import "SearchHistoryModel+CoreDataProperties.h"

@implementation SearchHistoryModel (CoreDataProperties)

+ (NSFetchRequest<SearchHistoryModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"SearchHistoryModel"];
}

@dynamic searchTitle;
@dynamic agencyId;

@end
