//
//  UITableView+BLEJReloadRowAndSection.m
//  Calculator
//
//  Created by 赵春浩 on 17/5/4.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import "UITableView+BLEJReloadRowAndSection.h"

@implementation UITableView (BLEJReloadRowAndSection)

// 此方法是为了刷新某一行或者是某一组(刷新某一组的时候, row传进来一个 -1 )
- (void)reloadTableViewWithRow:(NSInteger)row andSection:(NSInteger)section {
    
    if (row == -1) {// 刷新某一组
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
        [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        return;
    }
    
    [self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:(UITableViewRowAnimationNone)];
}

@end
