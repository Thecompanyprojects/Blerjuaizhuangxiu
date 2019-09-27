//
//  GoodsShareQRCodeView.h
//  iDecoration
//
//  Created by zuxi li on 2017/9/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsShareQRCodeView : UIView
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIImageView *QRCodeImageView;

@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *price;
@end

