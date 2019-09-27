//
//  worktypeVC.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/5/13.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SNViewController.h"
@class WorkTypeModel, LJCollectionViewFlowLayout;
@interface worktypeVC : SNViewController
typedef void(^worktypeVCBlock)(WorkTypeModel *model);
@property (copy, nonatomic) worktypeVCBlock blockDidTouchItem;
@property (strong, nonatomic) NSString *stringJob;
@property (nonatomic, strong) NSMutableArray *arrayDataTableView;
@property (nonatomic, strong) NSMutableArray *arrayDataCollectionView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LJCollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) WorkTypeModel *model;
@property (assign, nonatomic) NSInteger selectIndex;

- (void)Network;
@end
