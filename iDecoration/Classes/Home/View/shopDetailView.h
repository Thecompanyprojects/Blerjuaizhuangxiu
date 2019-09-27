//
//  shopDetailView.h
//  iDecoration
//
//  Created by 涂晓雨 on 2017/7/13.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol shopDetailViewDelagate <NSObject>

-(void)shopDetailActions:(NSInteger)tag;

@end

@interface shopDetailView : UIView


//标记viwe的tag
@property(nonatomic,assign)NSInteger  shopTag;


@property(nonatomic,weak)id<shopDetailViewDelagate> delegate;


//图片
@property(nonatomic,strong)UIImageView  *bgImage;

//标题

@property(nonatomic,strong)UILabel *titleLabel;



@end
