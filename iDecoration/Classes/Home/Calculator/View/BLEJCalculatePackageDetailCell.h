//
//  BLEJCalculatePackageDetailCell.h
//  iDecoration
//
//  Created by john wall on 2018/8/2.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEJPackageArticleDesignModel.h"
#import "BLEJCalculatorPackageTemplateModel.h"
#import "CLPlayerView.h"


@protocol BLRJCalculatePackageDetailCellDelegate<NSObject>

-(void)didselectVideoButtonClickAtIndexPath:(NSIndexPath* )path;
@end
@interface BLEJCalculatePackageDetailCell : UITableViewCell<CLPlayerViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>

@property(strong,nonatomic)NSIndexPath* pathVideoSelected;//选中的index 怕太好；
@property(assign,nonatomic) CGFloat cellHeight;  //cell 的返回的高度


@property(strong,nonatomic) UILabel *Name;  //contenView 的topLabel
@property(strong,nonatomic) UIImageView *imageShow;//图片
@property(strong,nonatomic) CLPlayerView *player;//视频
@property(strong,nonatomic)  UIImageView *plachoderVideoImgV;//视频遮罩
@property(strong,nonatomic) UITextView *textView;//文字


@property(nonatomic,weak)id<BLRJCalculatePackageDetailCellDelegate> PackageCellDelegate;
@property(strong,nonatomic)BLEJPackageArticleDesignModel* ArticleDesignModel;
@property(strong,nonatomic)BLEJCalculatorPackageTemplateModel*templateModel;
@end
