//
//  ZCHApplyCooperateCell.h
//  iDecoration
//
//  Created by 赵春浩 on 17/10/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCHCooperateListModel;
@class UnionInviteMessageModel;

@protocol ZCHApplyCooperateCellDelegate <NSObject>

@optional
- (void)didClickApplyBtnWithIndexPath:(NSIndexPath *)indexPath;
- (void)didClickCompanyLogoIndexPath:(NSIndexPath *)indexPath;

@end


@interface ZCHApplyCooperateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (strong, nonatomic) ZCHCooperateListModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<ZCHApplyCooperateCellDelegate> delegate;
@property (strong, nonatomic) ZCHCooperateListModel *msgModel;
@property (copy, nonatomic) NSString *currentCompanyId;
//@property (strong, nonatomic) ZCHCooperateListModel *detailMsgModel;
// 联盟邀请
@property (strong, nonatomic) UnionInviteMessageModel *unionMsgModel;
// 联盟申请
@property (strong, nonatomic) UnionInviteMessageModel *applyMsgModel;

@end
