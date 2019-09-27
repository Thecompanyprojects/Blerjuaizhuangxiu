//
//  ZCHGoodsShowCollectionViewCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCHGoodsShowModel;

typedef void(^ClickDeleteBtnBlock)(NSIndexPath *index);
@interface ZCHGoodsShowCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ZCHGoodsShowModel *model;
@property (strong, nonatomic) NSIndexPath * cellItem;
@property (copy, nonatomic) ClickDeleteBtnBlock clickDeleteBlock;
@property (assign, nonatomic) BOOL isShowDelete;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end
