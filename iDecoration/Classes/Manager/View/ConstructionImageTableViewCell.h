//
//  ConstructionImageTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPCommentView.h"
#import "TZImagePickerController.h"

@protocol ConstructionImageTableViewCellDelegate <NSObject>

-(void)deletePhotoWith:(NSInteger)deleteTag;

-(void)addPhoto;

-(void)lookPhoto:(NSInteger)index imgArray:(NSArray *)imgArray;

@end

@interface ConstructionImageTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>



+(instancetype)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)path;
-(void)configWith:(id)data isHavePower:(BOOL)isPower isEdit:(BOOL)isEdit;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic,strong)YPPhotosView *photosView;
@property (nonatomic, weak) id<ConstructionImageTableViewCellDelegate>delegate;
@end
