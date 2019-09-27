//
//  SearchCaseMaterialCell.h
//  iDecoration
//
//  Created by Apple on 2017/7/19.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCaseMaterialCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *HouseManL;
@property (weak, nonatomic) IBOutlet UILabel *ConsManL;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgV;

-(void)configData:(id)data;
@end
