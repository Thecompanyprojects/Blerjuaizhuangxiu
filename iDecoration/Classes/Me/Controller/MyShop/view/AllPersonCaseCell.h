//
//  AllPersonCaseCell.h
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AllPersonCaseCellDelegat <NSObject>

@optional

-(void)goToDiayVC:(NSInteger)tag;

-(void)circleBtnDo:(NSInteger )tag;

@end

@interface AllPersonCaseCell : UITableViewCell
@property (nonatomic ,strong) UIButton *circleBtn;
@property (nonatomic, strong) UIImageView *midV;
@property (nonatomic, strong) UILabel *villageL;
@property (nonatomic, strong) UILabel *areaNumL;
@property (nonatomic, strong) UILabel *styleL;

@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIImageView *browerImgV;

@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, weak) id<AllPersonCaseCellDelegat>delegate;

-(void)configData:(id)data isHavePower:(BOOL)isHavePower;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
