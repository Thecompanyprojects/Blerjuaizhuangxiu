//
//  VLoopScrollView.h
//  VLoopScrollView
//
//  Created by vincent on 16/5/17.
//  Copyright © 2016年 VinHand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VLoopScrollView : UIScrollView<UIScrollViewDelegate>


@property (nonatomic, weak) UIImageView *imageView_BEF;

@property (nonatomic, weak) UIImageView *imageView_MID;

@property (nonatomic, weak) UIImageView *imageView_AFT;

@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *adScrollTimer;

@property (nonatomic, strong) NSArray *adImageArray;

@property (nonatomic, assign) NSInteger currentPage;


/**
 *  Give it your params
 *
 *  @param imageArray : Your array of imageURLs
 */
- (void) v_logicalOfADScrollWithImageArray:(NSArray *)imageArray;

/**
 *  if you want repeat then add it
 */
- (void) v_addRepeatTimer;

/**
 *  remember remove after add Timer
 */
- (void) v_removeTimer;

/**
 *  about PageControl
 *
 *  @param number      total number of pages
 */
- (void) v_addPageControlWithNumberOfPage:(NSInteger)number currentPage:(NSInteger)currentPage controller:(UIViewController *)vc;

- (void) v_addPageControlWithNumberOfPage:(NSInteger)number currentPage:(NSInteger)currentPage view:(UIView *)view;

@end
