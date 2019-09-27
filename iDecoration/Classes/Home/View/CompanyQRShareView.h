//
//  CompanyQRShareView.h
//  iDecoration
//
//  Created by zuxi li on 2018/5/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CompanyQRShareView : UIView

@property (nonatomic,copy) void(^hiddenBlock)(CompanyQRShareView *QRView);

- (instancetype)initViewWithShareURLStr:(NSString *)shareURLStr shareImage:(UIImage*)companyLogo shareImageURLStr:(NSString *)imageURLStr companyName:(NSString *)companyName;

@end
