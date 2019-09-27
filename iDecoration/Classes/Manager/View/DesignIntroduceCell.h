//
//  DesignIntroduceCell.h
//  iDecoration
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DesignIntroduceCellDelegate <NSObject>
-(void)addDesignPhoto;
-(void)changeDesignPhoto:(NSIndexPath *)path;
-(void)saveContentWith:(NSIndexPath *)path content:(NSString *)content;

-(void)continueAdd;
-(void)deleteIntroductPhotoWith:(NSIndexPath *)path;

-(void)selectIsVail;
@end

@interface DesignIntroduceCell : UITableViewCell
@property (nonatomic, strong) UITextView *saySomeV;
@property (nonatomic, strong) UILabel *someL;
@property (nonatomic, strong) UIImageView *photoV;

@property (nonatomic, strong) UILabel *supportL;
@property (nonatomic, strong) UIButton *continueAddBtn;

@property (nonatomic, strong) UIButton *deleteModelBtn;
@property (nonatomic, strong) UIView *bottomV;
@property (nonatomic, strong) UILabel *lookL;


@property (nonatomic, strong) NSIndexPath *path;
+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
-(void)configWith:(id)data isPower:(BOOL)isPower isEdit:(BOOL)isEdit;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, weak) id<DesignIntroduceCellDelegate>delegate;
@end
