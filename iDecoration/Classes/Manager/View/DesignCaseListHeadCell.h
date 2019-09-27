//
//  DesignCaseListHeadCell.h
//  iDecoration
//
//  Created by Apple on 2017/8/2.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DesignCaseListHeadCellDelegate <NSObject>

-(void)changeCoverTitle;//修改主标题
-(void)changeCoverImg;
-(void)addMusic;

-(void)changeCoverTitleTwo;//修改副标题

@end

@interface DesignCaseListHeadCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backImgV;
@property (nonatomic, strong) UILabel *titleL;//主标题
@property (nonatomic, strong) UILabel *titleTwo;//副标题
@property (nonatomic, strong) UIButton *addMusicBtn;
@property (nonatomic, strong) UIButton *editCoverBtn;
@property (assign, nonatomic) BOOL isHaveMusicButton;

@property (nonatomic, weak) id<DesignCaseListHeadCellDelegate>delegate;

@property (nonatomic, assign) BOOL titleIsShow;//是否显示主标题和副标题。no:显示。yes：不显示

+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)configWith:(NSString *)title titleTwo:(NSString *)titleTwo coverImg:(NSString *)coverImg songName:(NSString *)songName;
@end
