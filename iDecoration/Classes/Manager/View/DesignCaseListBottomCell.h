//
//  DesignCaseListBottomCell.h
//  iDecoration
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DesignCaseListBottomCellDelegate <NSObject>

-(void)changeBottomHiddenState;
-(void)changeBottomToHidden;

@end

@interface DesignCaseListBottomCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *bottombackGroundV;

@property (nonatomic, strong) UIButton *bottomaddBtn;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *addVoteL;//投票

@property (nonatomic, strong) UIView *hiddenV;//隐藏或显示的view
-(void)configWith:(BOOL)isHidden;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, weak) id<DesignCaseListBottomCellDelegate>delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
