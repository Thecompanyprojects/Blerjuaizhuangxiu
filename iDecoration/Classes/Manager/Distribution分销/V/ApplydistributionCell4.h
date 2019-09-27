//
//  ApplydistributionCell4.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/6/19.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myapplydelegate <NSObject>

-(void)choosecodetypebtn0;
-(void)choosecodetypebtn1;
-(void)choosecodetypebtn2;

@end

@interface ApplydistributionCell4 : UITableViewCell
@property(assign,nonatomic)id<myapplydelegate>delegate;
@end
