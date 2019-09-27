//
//  ShopDetailBottomCell.h
//  iDecoration
//
//  Created by Apple on 2017/5/10.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopDetailBottomCellDelegate <NSObject>

@optional
-(void)addPeopleWith:(NSInteger)tag;

-(void)deletePeopleWith:(NSInteger)tag;

-(void)modifyJobWith:(NSInteger)tag;

-(void)lookDetailInfo:(NSInteger )tag;

@end

@interface ShopDetailBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoConW;

@property (weak, nonatomic) IBOutlet UIImageView *photoImg;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *jobL;
- (IBAction)detailInfoClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIButton *modefyJobBtn;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, weak) id<ShopDetailBottomCellDelegate>delegate;
-(void)configData:(id)data;
-(void)setImg:(id)imgchoose;
@end
