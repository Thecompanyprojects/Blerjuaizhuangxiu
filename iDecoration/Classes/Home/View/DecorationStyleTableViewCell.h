//
//  DecorationStyleTableViewCell.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/12.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectTypeDelegate <NSObject>

- (void)didSelectedTypeWithIndex:(NSInteger)index tap:(UITapGestureRecognizer *)tap;

@end

@interface DecorationStyleTableViewCell : UITableViewCell

@property (nonatomic, weak) id<SelectTypeDelegate> delegate;

@end
