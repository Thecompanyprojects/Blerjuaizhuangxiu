//
//  HomeClassificationDetailModel.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/9.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HomeClassificationDetailModel : NSObject
@property (assign, nonatomic) CGFloat viewLineBottomToRight;
@property (assign, nonatomic) CGFloat viewLineBottomToLeft;
@property (assign, nonatomic) CGFloat viewLineRightToBottom;
@property (assign, nonatomic) CGFloat viewLineRightToTop;
@property (assign, nonatomic) BOOL viewLineRightHidden;
@property (assign, nonatomic) BOOL viewLineBottomHidden;
@property (strong, nonatomic, readonly, class) NSArray *arrayTitle;
@property (strong, nonatomic, readonly, class) NSArray *arrayDetail;
@property (strong, nonatomic, readonly, class) NSArray *arrayDetailShop;
@property (strong, nonatomic, readonly, class) NSArray *newarrayDetailShop;
@property (strong, nonatomic, readonly, class) NSArray *arrayDetailIcon;
@property (strong, nonatomic, class) NSMutableArray *arrayIsSelected;

/**
 通过title比较获得type值

 @param title title
 */
+ (NSInteger)getTypeWithTitle:(NSString *)title;
+ (NSString *)getTitleWithType:(NSString *)type;
+ (NSString *)imageIconName:(NSString *)string;
- (void)setLinesWithIndex:(NSInteger)index AndIsBottom:(BOOL)isBottom;
@end
