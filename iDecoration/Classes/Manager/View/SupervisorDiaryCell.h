//
//  SupervisorDiaryCell.h
//  iDecoration
//
//  Created by Apple on 2017/7/5.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SupervisorDiaryCellDelegate <NSObject>

-(void)changeContentPhoto:(NSInteger)tag;
-(void)deleteContentPhoto:(NSInteger)tag;
-(void)editContent:(NSInteger)tag content:(NSString *)content;
@end

@interface SupervisorDiaryCell : UITableViewCell
@property (nonatomic, strong) NSIndexPath *path;

@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, assign) CGFloat imgVH;
@property (nonatomic, assign) CGFloat spacingH;

@property (nonatomic, strong) UITextView *sayTextV;
@property (nonatomic, strong) UILabel *placeholerL;
@property (nonatomic, strong) UIImageView *photoV;
@property (nonatomic, strong) UIButton *deleteContentBtn;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSMutableArray *array;
+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
-(void)configWith:(id)data count:(NSInteger)count indexPath:(NSIndexPath *)path isPower:(BOOL)isPower isEdit:(BOOL)isEdit;

@property (nonatomic, weak) id<SupervisorDiaryCellDelegate>delegate;
@end
