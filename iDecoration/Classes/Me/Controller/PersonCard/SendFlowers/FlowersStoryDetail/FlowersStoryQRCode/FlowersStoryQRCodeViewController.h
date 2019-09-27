//
//  FlowersStoryQRCodeViewController.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowersStoryQRCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewCenter;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopToTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTop;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *layoutHeight;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewQRCode;
@end
