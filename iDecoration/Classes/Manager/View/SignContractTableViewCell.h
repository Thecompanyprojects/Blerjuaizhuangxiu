//
//  SignContractTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/28.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignContractTableViewCellDelegate <NSObject>

-(void)zanWith:(NSIndexPath *)path;
-(void)commentWith:(NSIndexPath *)path;
-(void)editWith:(NSIndexPath *)path;
-(void)deletePointWith:(NSIndexPath *)path;
-(void)lookInfoWith:(NSIndexPath *)path;

// 评论内容操作
- (void)longPressCommentLabel:(UILabel *)label indexPath:(NSIndexPath *)path;
-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray;
@end


@interface SignContractTableViewCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *logo;
@property (strong, nonatomic)  UILabel *nameAndJob;
@property (strong, nonatomic)  UILabel *date;
@property (strong, nonatomic)  UIImageView *stateImage;
@property (strong, nonatomic)  UILabel *stateLabel;
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UIImageView *contactImage;
@property (strong, nonatomic)  UIButton *dianzan;
@property (strong, nonatomic)  UILabel *zanNumberLabel;
@property (strong, nonatomic)  UIButton *discussBtn;

@property (nonatomic, strong) UIView *lineV;
@property (strong, nonatomic) UIView *divView;

@property (nonatomic, strong) UIButton *isSelfEditBtn;

@property (nonatomic, strong) UIButton *deletePointBtn;

@property (nonatomic, strong) UIButton *lookDetailInfoBtn;//查看他人资料的按钮

@property (nonatomic, weak) id<SignContractTableViewCellDelegate>delegate;

@property (nonatomic, assign) CGFloat cellH;


+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
-(void)configData:(id)data indexpath:(NSIndexPath *)path isComplete:(NSInteger)isComplete isLogin:(BOOL)isLogin isExit:(BOOL)isExit type:(NSInteger)type nodeName:(NSString *)nodeName;// type 1:施工日志。2:主材日志  nodeName（节点名称）:施工日志可以不传

@property (nonatomic, strong)NSMutableArray *imgArray;

@property (nonatomic, strong) NSIndexPath *path;

@property (nonatomic, strong) NSMutableDictionary *cellHDict;
@property (nonatomic, strong) NSMutableDictionary *MaincellHDict;
@end
