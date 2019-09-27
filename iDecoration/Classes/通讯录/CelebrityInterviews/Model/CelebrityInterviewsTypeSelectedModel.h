//
//  CelebrityInterviewsTypeSelectedModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CelebrityInterviewsTypeSelectedModel : NSObject
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) BOOL isSelected;
@property (strong, nonatomic) NSString *title;

@end

NS_ASSUME_NONNULL_END
