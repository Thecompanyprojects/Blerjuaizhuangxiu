//
//  ActivityQRCodeShareView.h
//  iDecoration
//
//  Created by zuxi li on 2017/10/31.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityQRCodeShareView : UIView

@property (nonatomic, strong) UIImageView *topImageView;

@property (nonatomic, strong) UIImageView *companyIcon;

@property (nonatomic, strong) UIImageView *QRcodeView;



@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *activityTime;
@property (nonatomic, strong) NSString *activityAddress;

@end
