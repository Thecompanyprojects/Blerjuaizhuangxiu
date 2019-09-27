//
//  SearchCompanyCell.h
//  iDecoration
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCompanyCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UITextField *contentF;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) NSIndexPath *path;

+(instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)configWith:(id)data;

@end
