//
//  AddressBookCollectionViewCell1.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/15.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EliteListTableViewCell.h"

@interface AddressBookCollectionViewCell1 : UICollectionViewCell<UITableViewDelegate, UITableViewDataSource>
typedef void(^AddressBookCollectionViewCell1Block)(GeniusSquareListModel *model);

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (copy, nonatomic) AddressBookCollectionViewCell1Block blockDidtouchCell;

@end
