//
//  GoodsEditCell.h
//  iDecoration
//
//  Created by zuxi li on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsEditCellDelegate <NSObject>

-(void)changeHiddenState:(NSIndexPath *)path;
-(void)changeToHidden:(NSIndexPath *)path;
-(void)changePhotoCell:(NSIndexPath *)path;
-(void)addPhotoCell:(NSIndexPath *)path;
-(void)addTextCell:(NSIndexPath *)path;
-(void)addVideoCell:(NSIndexPath *)path;
-(void)removePhotoCell:(NSIndexPath *)path;
-(void)editTextCell:(NSIndexPath *)path;

-(void)moveCellToUp:(NSIndexPath *)path;
-(void)moveCellToDown:(NSIndexPath *)path;
@end

@interface GoodsEditCell : UITableViewCell
@property (nonatomic, strong) UIView *backGroundV;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *photoImgV;
@property (nonatomic, strong) UILabel *textL;


@property (nonatomic, strong) UIView *hiddenV;//隐藏或显示的view
@property (nonatomic, strong) UIButton *addTextBtn;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property (nonatomic, strong) UIButton *addVideoBtn;

@property (nonatomic, strong) UIButton *moveUpBtn;
@property (nonatomic, strong) UIButton *moveDownBtn;

@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, assign) CGFloat cellH;
-(void)configWith:(BOOL)isHidden data:(id)data isHaveDefaultLogo:(BOOL)isHaveDefaultLogo;
+(instancetype)cellWithTableView:(UITableView *)tableView path:(NSIndexPath *)path;
@property (nonatomic, weak) id<GoodsEditCellDelegate> delegate;
@end
