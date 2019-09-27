//
//  AllPersonBeautilArtCell.h
//  iDecoration
//
//  Created by sty on 2018/1/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllPersonBeautilArtCellDelegat <NSObject>

@optional
-(void)circleBtnDo:(NSInteger )tag;

@end

@interface AllPersonBeautilArtCell : UITableViewCell
@property (nonatomic ,strong) UIButton *circleBtn;

@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *midV;
@property (nonatomic, strong) UILabel *numL;
//@property (nonatomic, strong) UILabel *browerL;//展现量
@property (nonatomic, strong) UIImageView *browerImgV;

@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, strong) NSIndexPath *path;

@property (nonatomic, weak) id<AllPersonBeautilArtCellDelegat>delegate;

-(void)configData:(id)data isSelect:(BOOL)isSelect isHavePower:(BOOL)isHavePower;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
