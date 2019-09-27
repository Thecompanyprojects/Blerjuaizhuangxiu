//
//  fullSenceCollectionViewCell.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/9/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "senceModel.h"


@protocol cellDelegate <NSObject>

-(void)editorCell:(NSInteger)tag;

-(void)deleteCell:(NSInteger)tag;

@end



@interface fullSenceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgimage;
@property (weak, nonatomic) IBOutlet UIButton *editorBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *dispalyNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dispalyNumberNameLabel;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;


@property(weak, nonatomic) id<cellDelegate>  delegate;

@property(nonatomic,strong)senceModel *model;


@end
