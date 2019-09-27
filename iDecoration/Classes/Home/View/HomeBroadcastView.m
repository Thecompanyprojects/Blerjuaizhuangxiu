//
//  HomeBroadcastView.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/7.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "HomeBroadcastView.h"
#import "NetworkOfHomeBroadcast.h"

@implementation HomeBroadcastView

- (void)drawRect:(CGRect)rect {

}

- (void)setDataWith:(NetworkOfHomeBroadcast *)model {
    //0:在线预约,1:计算器,2:活动线下,4:线上活动）
    [self.labelDetail removeAllSubViews];
    self.textScrollView = [[LRSTextScrollView alloc] initWithFrame:CGRectMake(0, 0, self.labelDetail.width, self.labelDetail.height)];
    [self.labelDetail addSubview:self.textScrollView];
    self.textScrollView.BGColor = [UIColor clearColor];
    [self.textScrollView clickTitleLabel:^(NSInteger index, NSString *titleString) {
        if (self.blockDidtouchLabel) {
            self.blockDidtouchLabel();
        }
    }];
    NSMutableArray *array = model.arrayString.mutableCopy;
    self.textScrollView.imageView = self.imageViewType;
    self.textScrollView.model = model;
    [self.textScrollView setTitleArray:array andScrollDirection:(UIVerticalScrollDirection)];
    self.textScrollView.loopCount = 4;
    if ([model.todayCounts integerValue]) {
        self.labelTitle.text = @"今日";
        self.labelCount.text = model.todayCounts;
    }else{
        self.labelTitle.text = @"昨日";
        self.labelCount.text = model.yesterDayCounts?:@"0";
    }
    [self.imageViewType setImage:[UIImage imageNamed:model.arrayImageName[model.type]]];
}

@end
