//
//  AllPersonGoodsCell.h
//  iDecoration
//
//  Created by sty on 2018/1/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AllPersonGoodsCellDelegat <NSObject>

@optional
-(void)circleBtnDo:(NSInteger )tag;

@end

@interface AllPersonGoodsCell : UITableViewCell
@property (nonatomic ,strong) UIButton *circleBtn;
@property (nonatomic, strong) UIImageView *midV;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UILabel *nameL;

@property (nonatomic, strong) UIView *lineV;

@property (nonatomic, weak) id<AllPersonGoodsCellDelegat>delegate;

-(void)configData:(id)data;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
