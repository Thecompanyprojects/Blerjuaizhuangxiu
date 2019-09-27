//
//  communitymanagerHeader.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class localcommunityModel;
@interface communitymanagerHeader : UICollectionReusableView
-(void)setdata:(localcommunityModel *)model;
@property (nonatomic,strong) UIButton *chooseleftBtn;
@property (nonatomic,strong) UIButton *chooserightBtn;
@end

NS_ASSUME_NONNULL_END
