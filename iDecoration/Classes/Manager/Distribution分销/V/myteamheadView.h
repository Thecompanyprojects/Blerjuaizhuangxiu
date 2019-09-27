//
//  myteamheadView.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/4/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myteamheadView : UIView
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIImageView *infoimg;
@property (nonatomic,strong) UILabel *nameLab;
-(void)setdata:(NSString *)truename andcreateCode:(NSString *)createCode;
@end
