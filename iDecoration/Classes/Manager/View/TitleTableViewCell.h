//
//  TitleTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 17/3/22.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"
#import "SiteModel.h"

@protocol TitleTableViewCellDelegate <NSObject>

-(void)addPeople;

-(void)reducePeople;

-(void)deleteWith:(NSInteger)tag;

-(void)lookDetailInfo:(NSInteger)tag;
@end

@interface TitleTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isShowReduceBtn;

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *reduceBtn;
+(instancetype)cellWithTableView:(UITableView *)tableView;
-(void)configWith:(id)data;

-(void)configWith:(id)data siteModel:(SiteModel *)siteModel;

//-(void)configWith:(id)data isLogin:(BOOL)isLogin ccComplete:(bool)ccComplete isExit:(BOOL)isExit cJobTypeId:(NSInteger)cJobTypeId;
-(void)configWith:(id)data isLogin:(BOOL)isLogin ccComplete:(NSInteger)ccComplete isExit:(BOOL)isExit cJobTypeId:(NSInteger)cJobTypeId;
@property (nonatomic, weak) id<TitleTableViewCellDelegate>delegate;
@property (nonatomic, assign) CGFloat cellH;

@end
