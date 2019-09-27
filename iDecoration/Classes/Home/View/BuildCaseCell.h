//
//  BuildCaseCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuildCaseCellDelegate <NSObject>

@optional
- (void)didClickSupportBtn:(UIButton *)btn withIndex:(NSInteger)index;

@end

@interface BuildCaseCell : UITableViewCell

@property (weak, nonatomic) id<BuildCaseCellDelegate> buildCaseCellDelegate;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) BOOL beSelected;
@property (nonatomic, strong) UILabel *commentCountL;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)configWith:(id)data;



@end
