//
//  newWSRedPacketView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "newWSRewardConfig.h"

typedef void(^WSCancelBlock)(void);
typedef void(^WSFinishBlock)(float money);

@interface newWSRedPacketView : UIViewController
+ (instancetype)showRedPackerWithData:(newWSRewardConfig *)data
                          cancelBlock:(WSCancelBlock)cancelBlock
                          finishBlock:(WSFinishBlock)finishBlock;
@end
