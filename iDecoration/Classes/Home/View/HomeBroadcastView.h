//
//  HomeBroadcastView.h
//  iDecoration
//
//  Created by 张毅成 on 2018/6/7.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRSTextScrollView.h"
#import "NetworkOfHomeBroadcast.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^HomeBroadcastViewBlock)(void);
@interface HomeBroadcastView : UIView
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (copy, nonatomic) HomeBroadcastViewBlock blockDidtouchLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIButton *buttonSound;
@property (weak, nonatomic) IBOutlet LRSTextScrollView *labelDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewType;
@property (strong, nonatomic) LRSTextScrollView *textScrollView;
- (void)setDataWith:(NetworkOfHomeBroadcast *)model;
@end

NS_ASSUME_NONNULL_END
