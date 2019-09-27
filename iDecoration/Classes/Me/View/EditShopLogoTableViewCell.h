//
//  EditShopLogoTableViewCell.h
//  iDecoration
//
//  Created by RealSeven on 2017/4/1.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditShopLogoTableViewCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (nonatomic, copy) void(^tapBlock)();
@end
