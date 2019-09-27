//
//  ShopCaseMaterialCell.h
//  iDecoration
//
//  Created by sty on 2017/12/20.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopCaseMaterialCellDelegate <NSObject>
-(void)deleteShopCaseWithRow:(NSInteger)row tag:(NSInteger)tag;

-(void)zanShopCaseWith:(NSIndexPath *)path;

-(void)goGoodsDetailWithRow:(NSInteger)row tag:(NSInteger)tag;
@end


@interface ShopCaseMaterialCell : UITableViewCell


@property (strong, nonatomic)  UIImageView *logo;
@property (strong, nonatomic)  UILabel *nameAndJob;
@property (strong, nonatomic)  UILabel *date;
@property (strong, nonatomic)  UIImageView *stateImage;
@property (strong, nonatomic)  UILabel *stateLabel;

@property (strong, nonatomic)  UIButton *dianzan;
@property (strong, nonatomic)  UILabel *zanNumberLabel;



@property (nonatomic, assign) CGFloat cellH;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;

@property (nonatomic, strong) NSIndexPath *path;
-(void)configData:(id)data isComplete:(NSInteger)isComplete;

@property (nonatomic, weak) id<ShopCaseMaterialCellDelegate>delegate;
@end
