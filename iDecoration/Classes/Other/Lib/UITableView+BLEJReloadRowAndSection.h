//
//  UITableView+BLEJReloadRowAndSection.h
//  Calculator
//
//  Created by 赵春浩 on 17/5/4.
//  Copyright © 2017年 BLEJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (BLEJReloadRowAndSection)

/**
 *  tableView刷新某一组的某一行(默认是没有动画的(UITableViewRowAnimationNone), 这里的动画效果没有对外提供接口)
 *  tableView这里也可以刷新某一组, 需要传进来一个row = -1, 这里默认也是没有动画的(UITableViewRowAnimationNone)
 *  @param row     行号
 *  @param section 组号
 */
- (void)reloadTableViewWithRow:(NSInteger)row andSection:(NSInteger)section;

@end
