//
//  AddressBookCollectionViewCell2.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookCollectionViewCell2.h"

@implementation AddressBookCollectionViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [UIColor hexStringToColor:@"e1e1e1"].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = 4.0f;
}

@end
