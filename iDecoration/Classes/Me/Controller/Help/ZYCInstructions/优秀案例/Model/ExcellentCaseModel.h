//
//  ExcellentCaseModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/30.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExcellentCaseModel : NSObject

/**

 */
@property (copy, nonatomic) NSString *caseId;

/**

 */
@property (copy, nonatomic) NSString *caseHref;
@property (copy, nonatomic) NSString *caseTitle;
@property (copy, nonatomic) NSString *addTime;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSURL *coverMap;

@end

NS_ASSUME_NONNULL_END
