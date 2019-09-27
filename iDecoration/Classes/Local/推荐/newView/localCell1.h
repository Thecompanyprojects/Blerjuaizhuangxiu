//
//  localCell1.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/23.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localdesignModel;
@class localimgModel;
@protocol mydesignTabVdelegate <NSObject>
-(void)mydesign:(localdesignModel *)model;
-(void)myimg:(localimgModel *)model;
-(void)morebtnchoose:(NSString *)type;
@end
@interface localCell1 : UITableViewCell
@property (nonatomic,strong) UIButton *moreBtn;
-(void)setdata:(NSMutableArray *)imgarr and:(NSMutableArray *)designarr;
@property(assign,nonatomic)id<mydesignTabVdelegate>delegate;
@end
