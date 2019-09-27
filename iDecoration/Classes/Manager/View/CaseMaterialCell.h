//
//  CaseMaterialCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaseMaterialCellDelegate <NSObject>

-(void)CasecommentWith:(NSIndexPath *)path;
-(void)CasezanWith:(NSIndexPath *)path;

-(void)goCaseMatialVcWith:(NSIndexPath *)path;
-(void)goShopWith:(NSIndexPath *)path;
-(void)deleteShopWith:(NSIndexPath *)path;

//打赏
-(void)rewardAction:(NSIndexPath *)path;

@end

@interface CaseMaterialCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@property (nonatomic, weak) id<CaseMaterialCellDelegate>delegate;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *commentL;
@property (nonatomic, strong) UIButton *deleteBtn;


-(void)configWith:(id)data;
@end
