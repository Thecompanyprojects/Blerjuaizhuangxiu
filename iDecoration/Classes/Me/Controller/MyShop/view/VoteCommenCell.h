//
//  VoteCommenCell.h
//  iDecoration
//
//  Created by sty on 2018/3/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoteCommenCellDelegate <NSObject>

-(void)deleteVote;
@end

@interface VoteCommenCell : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *addVoteL;//投票


@property (nonatomic, strong) UILabel *voteTitleL;//投票描述
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *votePlacholdV;//投票的默认占位图

@property (nonatomic, weak) id<VoteCommenCellDelegate>delegate;

-(void)configCrib:(NSString *)cribStr isHaveVote:(BOOL)isHaveVote;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
