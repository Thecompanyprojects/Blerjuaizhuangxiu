//
//  NewMyPersonCardFiveCell.h
//  iDecoration
//
//  Created by sty on 2018/1/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeautifulArtCardModel.h"

@interface NewMyPersonCardFiveCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *midV;
@property (nonatomic, strong) UILabel *numL;
//@property (nonatomic, strong) UILabel *browerL;//展现量
@property (nonatomic, strong) UIImageView *browerImgV;

@property (nonatomic, strong) UIView *lineV;

-(void)configData:(id)data;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
@end
