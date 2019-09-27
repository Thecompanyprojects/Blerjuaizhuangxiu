//
//  SelectBgmCell.h
//  iDecoration
//
//  Created by sty on 2017/8/30.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectBgmCellDelegate <NSObject>

-(void)openOrCloseTargetWith:(NSIndexPath *)path;
-(void)selectMusicPath:(NSIndexPath *)path tag:(NSInteger)tag;
@end

@interface SelectBgmCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView path:(NSIndexPath *)path;
@property (nonatomic ,strong) NSIndexPath *path;

// isShowHeadCheck:是否显示头部的对号
// musicTag:选中的是哪个歌
-(void)configWith:(NSString *)headTitle count:(NSInteger)count dataArray:(NSArray *)dateArray isOpen:(BOOL)isOpen isShowHeadCheck:(BOOL)isShowHeadCheck musicTag:(NSInteger)musicTag;
@property (nonatomic ,strong) UIView *backGronudV;

@property (nonatomic, strong) UILabel *headTitleL;//标题
@property (nonatomic, strong) UILabel *numL;//数量
@property (nonatomic, strong) UIImageView *checkImg;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, weak) id<SelectBgmCellDelegate>delegate;

@end
