//
//  NewMyPersonCardSixCell.h
//  iDecoration
//
//  Created by sty on 2018/1/29.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMyPersonCardSixCellDelegat <NSObject>

@optional
-(void)goGoodsVc:(NSInteger)tag;

@end

@interface NewMyPersonCardSixCell : UITableViewCell


@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, weak) id<NewMyPersonCardSixCellDelegat>delegate;
-(void)configData:(NSMutableArray *)array;


+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
