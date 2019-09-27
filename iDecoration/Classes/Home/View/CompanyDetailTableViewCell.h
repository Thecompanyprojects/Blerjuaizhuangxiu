//
//  CompanyDetailTableViewCell.h
//  iDecoration
//
//  Created by Life's a struggle on 2017/4/17.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DidSelectDetailDelegate <NSObject>

@optional
- (void)didSelectDetailActionWithTag:(NSInteger)tag;

- (void)didClickTopImage;

@end

@interface CompanyDetailTableViewCell : UITableViewCell

@property (nonatomic, weak) id<DidSelectDetailDelegate> delegate;

@property (nonatomic, strong) UIImageView *topImage;

@property (assign, nonatomic) CGSize size;

@end
