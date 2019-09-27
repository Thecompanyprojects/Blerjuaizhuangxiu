//
//  OwnerDiaryCell.h
//  iDecoration
//
//  Created by Apple on 2017/6/3.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPCommentView.h"
#import "TZImagePickerController.h"

@protocol OwnerDiaryCellDelegate <NSObject>



-(void)deleteModelWithPath:(NSIndexPath *)path;

-(void)deletePhotoWith:(NSInteger)deleteTag path:(NSIndexPath *)path;

-(void)addPhotoWithPath:(NSIndexPath *)path;

-(void)lookPhoto:(NSInteger)index imgArray:(NSMutableArray *)imgArray path:(NSIndexPath *)path;

-(void)saveContentWith:(NSIndexPath *)path content:(NSString *)content;

-(void)continueAddWithPath:(NSIndexPath *)path;


@end

@interface OwnerDiaryCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIButton *deleteModelBtn;
@property (nonatomic, strong) UITextView *saySomeV;
@property (nonatomic, strong) UILabel *someL;
@property (nonatomic,strong)YPPhotosView *photosView;

//@property (nonatomic, strong) UIButton *continueAddBtn;
@property (nonatomic, strong) UIView *lineVOne;
@property (nonatomic, strong) UIView *lineVTwo;

@property (nonatomic, strong) NSIndexPath *path;
@property (nonatomic, weak) id<OwnerDiaryCellDelegate>delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
-(void)configWith:(id)data isShowAdd:(BOOL)isShowAdd;
@end
