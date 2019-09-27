//
//  PromptModel.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/4.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "PromptModel.h"

@implementation PromptModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"promptID":@"id"};
}


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [PromptGoodsList class]};
    
}
@end


@implementation PromptGoodsList

@end


//@implementation PromptMerchandiesList
//@end

