//
//  AddressBookTableViewCell.h
//  iDecoration
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeniusSquareListModel.h"

@interface AddressBookTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UIButton *buttonAll;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrayData;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger dataCount;

typedef void(^AddressBookTableViewCellBlock)(void);
typedef void(^AddressBookTableViewCellBlockWithValue)(NSString *string);
typedef void(^AddressBookTableViewCellBlockWithModel)(GeniusSquareListModel *model);
@property (copy, nonatomic) AddressBookTableViewCellBlock blockDidTouchButtonAll;
@property (copy, nonatomic) AddressBookTableViewCellBlockWithValue blockDidTouchItem;
@property (copy, nonatomic) AddressBookTableViewCellBlockWithModel blockDidTouchTableViewCell;

- (void)reloadDataWithArray:(NSMutableArray *)array AndIndex:(NSInteger)index;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
