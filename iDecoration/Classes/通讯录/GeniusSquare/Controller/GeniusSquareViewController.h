//
//  GeniusSquareViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeniusSquareViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic) NSMutableArray * arrayData;
@end
