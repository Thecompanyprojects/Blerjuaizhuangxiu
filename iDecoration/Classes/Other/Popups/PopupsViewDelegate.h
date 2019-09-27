//
//  PopupsView.h
//  Popups
//
//  Created by Arthur on 2018/5/30.
//  Copyright © 2018年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PopupsViewDelegate;


@protocol POAlertViewDelegate <NSObject>

- (void)didSelectedCancel:(PopupsViewDelegate *)popView withImageName:(NSString *)imageName;
-(void)phoneclick:(NSInteger )index;
-(void)wxclick:(NSInteger )index;
-(void)qqclick:(NSInteger )index;
@end

@interface PopupsViewDelegate : UIView

@property (nonatomic, weak) id<POAlertViewDelegate> delegate;


- (instancetype)initWithImage:(NSString *)imageName;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic,strong) UICollectionView *collectionView;
- (void)showView;

-(void)dismissAlertView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end
