//
//  JinQiViewController.h
//  iDecoration
//
//  Created by john wall on 2018/9/26.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JinQiViewController : UIViewController
@property(assign,nonatomic) BOOL  IsSelectedBigJinQi;

@property(strong,nonatomic)NSString *companyId;
@property(strong,nonatomic)NSString *payMoney;

@property(strong,nonatomic)NSIndexPath *indexPathup;
@property(strong,nonatomic)NSIndexPath *indexPathdown;

@property(strong,nonatomic)NSString *flowID;
@property(nonatomic,strong) NSString* penentID;
@property(nonatomic,strong) NSString* agencyId;
@property(nonatomic,assign) BOOL isSendFromCompany;
@property (nonatomic, copy) void(^completionBlock)(NSString * count);

@end
