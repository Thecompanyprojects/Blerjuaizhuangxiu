//
//  ZCHConstructionCommentController.h
//  iDecoration
//
//  Created by 赵春浩 on 17/6/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackRefreshBlock)();
@interface ZCHConstructionCommentController : UITableViewController

@property (copy, nonatomic) NSString *constructionId;
@property (assign, nonatomic) BOOL isNewComment;
@property (copy, nonatomic) BackRefreshBlock refreshBlock;

@end
