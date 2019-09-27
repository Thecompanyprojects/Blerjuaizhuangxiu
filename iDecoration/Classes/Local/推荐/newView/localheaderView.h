//
//  localheaderView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/21.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "localchooseView0.h"
#import "localchooseView1.h"

@protocol seemoreTabVdelegate <NSObject>
-(void)myTabVClick0:(NSInteger )Integer;
-(void)myTabVClick1:(NSInteger )Integer;
-(void)myTabVClick2:(NSInteger )Integer;
@end
@interface localheaderView : UIView
@property (nonatomic,strong) UIButton *btn0;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UIButton *btn3;
@property (nonatomic,strong) UIButton *rankingmoreBtn;
@property (nonatomic,strong) UIButton *bobaomoreBtn;
@property (nonatomic,strong) localchooseView0 *chooseView0;
@property (nonatomic,strong) localchooseView1 *chooseView1;
@property (nonatomic,strong) localchooseView1 *chooseView2;
-(void)setbanner:(NSMutableArray *)banner;
-(void)setdatafrom:(NSMutableArray *)labelarray;
-(void)setdatarr0:(NSMutableArray *)arr0 andarr1:(NSMutableArray *)arr1 andarr2:(NSMutableArray *)arr2;
@property(assign,nonatomic)id<seemoreTabVdelegate>delegate;
@end
