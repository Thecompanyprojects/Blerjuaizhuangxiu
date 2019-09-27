//
//  localcaseCell.h
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
@class localcaseModel;
@interface localcaseCell : UICollectionViewCell
-(void)setdata:(localcaseModel *)model withtype:(NSString *)type;
@end
