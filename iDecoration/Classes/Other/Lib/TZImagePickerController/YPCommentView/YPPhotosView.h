//
//  YPPhotosView.h
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^visitCameraBlock)();
typedef void(^removeImageBlock)(NSInteger index);


@interface YPPhotosView : UIView
/**存放图片的数组*/
@property (nonatomic,strong) NSArray *photoArray;
@property (nonatomic,strong) UICollectionView *collectionView ;

//横向排列
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isRow;//是否横向排版
@property (nonatomic, assign) BOOL isShowAddBtn;//是否显示最后一个加号图片


@property (nonatomic, assign) BOOL isShowZongAddBtn;//是否显示纵向布局的最后一个加号图片  no:  不显示  yes：显示
/**调用相册*/
@property (nonatomic,copy) visitCameraBlock clickChooseView;
@property (nonatomic,copy) removeImageBlock clickcloseImage;

@property (nonatomic,copy) void(^clicklookImage)(NSInteger tag , NSArray *imageArr);
@property (nonatomic,copy) void(^clickHiddenKeyBoard)();
/// 外部API 选择图片完成是调用
- (void)setYPPhotosView:(NSArray *)photoArray ;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL isShowDeleteBtn; //yes： 隐藏删除按钮 no：显示删除按钮

@property (nonatomic, assign) BOOL isShowScrDeleteBtn;//是否显示横向排版的删除按钮

@property (nonatomic,copy) void(^changeImage)(NSIndexPath *fromPath , NSIndexPath *toPath);
@end
