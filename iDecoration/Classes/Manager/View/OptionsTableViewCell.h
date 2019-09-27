//
//  OptionsTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/14.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *optionCollectionView;

@property (nonatomic, strong) void(^designBlock)();
@property (nonatomic, strong) void(^memberBlock)();
@property (nonatomic, strong) void(^holderBlock)();
@property (nonatomic, strong) void(^supervisorBlock)();
@property (nonatomic, strong) void(^fiveBlock)();

@property (nonatomic, assign) NSInteger fromTag; //1:施工日志使用 2:主材日志使用


@end
