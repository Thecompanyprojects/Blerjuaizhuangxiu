//
//  MainMaterialDiaryHeadCell.h
//  iDecoration
//
//  Created by Apple on 2017/6/7.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainMaterialDiaryHeadCellDelegate <NSObject>


-(void)modifyCon;
-(void)goToShopLook;
@end

@interface MainMaterialDiaryHeadCell : UITableViewCell
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, assign) CGFloat cellHeight;
+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@property (nonatomic, weak)id<MainMaterialDiaryHeadCellDelegate>delegate;
-(void)configWith:(id)data;
@end
