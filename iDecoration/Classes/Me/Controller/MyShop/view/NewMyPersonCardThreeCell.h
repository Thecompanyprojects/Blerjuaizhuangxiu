//
//  NewMyPersonCardThreeCell.h
//  iDecoration
//
//  Created by sty on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMyPersonCardThreeCell : UITableViewCell
@property (nonatomic, strong) UIView *firstV;
@property (nonatomic, strong) UILabel *personL;//个人简介
@property (nonatomic ,strong) UIView *SegmentLeftV;
@property (nonatomic ,strong) UIView *SegmentRightV;

@property (nonatomic, strong) UIView *secondV;
@property (nonatomic, strong) UILabel *detailL;

@property (nonatomic, assign) CGFloat cellH;
-(void)configWith:(NSString *)indu;


+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
