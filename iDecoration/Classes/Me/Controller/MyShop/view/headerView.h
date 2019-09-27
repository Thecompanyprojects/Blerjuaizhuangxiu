//
//  headerView.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/6.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol upDataImageDelegate <NSObject>

-(void)updataimage;

@end


@interface headerView : UIView


@property(nonatomic,strong)UIButton *addImageBtn;


@property(nonatomic,strong)UIImageView *headImage;

@property(nonatomic,weak)id<upDataImageDelegate>  delegate;
@end
