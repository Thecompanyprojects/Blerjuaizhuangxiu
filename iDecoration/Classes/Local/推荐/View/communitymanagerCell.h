//
//  communitymanagerCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/20.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class communitymanagerModel;
@class communitymanagerModel2;

NS_ASSUME_NONNULL_BEGIN

@interface communitymanagerCell : UICollectionViewCell

-(void)setdata:(communitymanagerModel *)model;
-(void)setdata2:(communitymanagerModel2 *)model;
@end

NS_ASSUME_NONNULL_END
