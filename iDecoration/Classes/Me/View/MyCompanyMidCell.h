//
//  MyCompanyMidCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/8.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCompanyMidCellDelegate <NSObject>

@optional
-(void)deleteCompanyWith:(NSIndexPath *)path;
-(void)selectCompanyWith:(NSIndexPath *)path;

@end

@interface MyCompanyMidCell : UITableViewCell

@property (nonatomic, strong) UITextField *textF;

@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UILabel *contentL;
@property (nonatomic, strong) UIImageView *rightRow;
@property (nonatomic, strong) UILabel *companySign;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, weak) id<MyCompanyMidCellDelegate>delegate;


+(instancetype)cellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(void)configWith:(id)data;
@end
