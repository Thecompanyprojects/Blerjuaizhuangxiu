//
//  ZCHCooperateAndUnionCell.h
//  iDecoration
//
//  Created by 赵春浩 on 2017/11/23.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCHCooperateListModel;

@protocol ZCHCooperateAndUnionCellDelegate <NSObject>

@optional
- (void)didClickApplyBtnWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZCHCooperateAndUnionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) ZCHCooperateListModel *model;
@property (strong, nonatomic) ZCHCooperateListModel *unionModel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ZCHCooperateAndUnionCellDelegate> delegate;
@property (copy, nonatomic) NSString *currentCompanyId;

@end
