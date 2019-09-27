//
//  RedCommenCell.h
//  iDecoration
//
//  Created by sty on 2018/3/6.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RedCommenCellDelegate <NSObject>
-(void)deleteRedWith:(NSInteger)tag;
@end

@interface RedCommenCell : UITableViewCell
@property (nonatomic, strong) UIView *redView;

@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *addRedL;//投票


@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, weak) id<RedCommenCellDelegate>delegate;
-(void)configArray:(NSMutableArray *)array isHaveRed:(BOOL)isHaveRed;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
