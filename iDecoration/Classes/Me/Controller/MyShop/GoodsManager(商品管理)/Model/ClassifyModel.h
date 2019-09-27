//
//  ClassifyModel.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/18.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject

+ (instancetype)newModelWithID:(NSInteger)categoryID andCategoryName:(NSString *)categoryName;

@property (nonatomic, assign) NSInteger categoryID;
@property (nonatomic, copy) NSString *categoryName;
@end
