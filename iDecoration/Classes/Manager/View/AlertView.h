//
//  AlertView.h
//  UIalertView
//
//  Created by apple on 16/5/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject>


@optional

-(void)clickButton:(NSInteger)index;

-(void)leftclick;
-(void)rightclick;

-(void)pushclick;
@end

@interface AlertView : UIView

@property(nonatomic,copy)void (^GlodeBottomView)(NSInteger index ,NSString *string);
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)id<AlertViewDelegate>delegate;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) UIButton *leftBtn;//公司常用语选择
@property(nonatomic,strong) UIButton *rightBtn;//系统常用语选择
@property(nonatomic,strong) UIButton *imgbtn;

@property (nonatomic,assign) BOOL isshow;
+(id)GlodeBottomView;

-(void)show;
-(void)dissMIssView;
@end
