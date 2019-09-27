//
//  AddressBookModel.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookModel.h"
static NSArray *_arrayViewCircleColor;
static NSArray *_arrayLabelTitle;
@implementation AddressBookModel
+ (NSArray *)arrayLabelTitle {
    return @[@"人才广场", @"精英推荐", @"诚信档案", @"名人专访"];
}

+ (NSArray *)arrayViewCircleColor {
    return @[[UIColor colorWithRed:0.09 green:0.69 blue:0.50 alpha:1.00], [UIColor colorWithRed:0.23 green:0.58 blue:0.90 alpha:1.00], [UIColor colorWithRed:0.96 green:0.64 blue:0.29 alpha:1.00], [UIColor colorWithRed:0.93 green:0.33 blue:0.08 alpha:1.00]];
}
@end
