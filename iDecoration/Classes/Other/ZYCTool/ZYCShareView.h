//
//  ZYCShareView.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/22.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenShare/OpenShareHeader.h>
#import "FlowersStoryQRCodeViewController.h"

typedef NS_ENUM(NSInteger,ZYCShareViewType){
    ZYCShareViewTypeDefault,//both
    ZYCShareViewTypeEmployeesOnly,//只有员工
    ZYCShareViewTypeCompanyOnly,//只有公司
    ZYCShareViewTypeNone//没有二维码
};

@interface ZYCShareView : UIView
typedef void (^ZYCShareViewBlock)(void);
@property (strong, nonatomic) UIView *shareView;
@property (strong, nonatomic) UIView *shadowView;
@property (copy, nonatomic) NSString *URL;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareCompanyIntroduction;
@property (copy, nonatomic) NSString *shareCompanyLogo;
@property (strong, nonatomic) UIImage *shareCompanyLogoImage;

/**

 */
@property (strong, nonatomic) OSMessage *message;
@property (copy, nonatomic) ZYCShareViewBlock blockQQFriend;
@property (copy, nonatomic) ZYCShareViewBlock blockQQZone;
@property (copy, nonatomic) ZYCShareViewBlock blockWeChatFriend;
@property (copy, nonatomic) ZYCShareViewBlock blockWeChatTimeline;
@property (copy, nonatomic) ZYCShareViewBlock blockQRCode1st;
@property (copy, nonatomic) ZYCShareViewBlock blockQRCode2nd;
@property (assign, nonatomic) ZYCShareViewType shareViewType;

- (void)showShareView;
+ (instancetype)sharedInstance;
- (void)share;
@end
