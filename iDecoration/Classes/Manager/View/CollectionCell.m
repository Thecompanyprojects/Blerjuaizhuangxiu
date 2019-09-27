//
//  CollectionCell.m
//  iDecoration
//
//  Created by 丁 on 2018/3/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "CollectionCell.h"

#define Start_X         20.0f  // 第一个按钮的X坐标
#define Start_Y         50.0f  // 第一个按钮的Y坐标
#define Width_Space     50.0f  // 两个按钮之间的横间距
#define Height_Space    60.0f  // 两个按钮之间的竖间距
#define Button_Width    100.0f // 宽
#define Button_Height   70.0f  // 高


@interface CollectionCell ()
//@property(nonatomic, strong) UIButt;on

@end
@implementation CollectionCell

- (void)addButtons{
    for (int i = 0;i < 18 ; i++) {
        NSInteger index = i % 3;
        NSInteger page = i / 3;
        UIButton *ManageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        ManageBtn.tag = i;
        ManageBtn.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page * (Button_Height + Height_Space) + Start_Y,Button_Width , Button_Height);
        [ManageBtn addTarget:self action:@selector(manageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)manageBtnClick:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
}

-(instancetype)initWithFrame:(CGRect)frame{

    return self;
}

@end
