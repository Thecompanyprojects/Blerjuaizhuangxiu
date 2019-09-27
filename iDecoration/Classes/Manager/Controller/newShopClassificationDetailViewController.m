//
//  newShopClassificationDetailViewController.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/7/30.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "newShopClassificationDetailViewController.h"
#import "CollectionViewCell.h"

@interface newShopClassificationDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) WorkTypeModel *model;

@end

@implementation newShopClassificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺类别";
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumInteritemSpacing = Width_Layout(30);
    self.flowLayout.minimumLineSpacing = Height_Layout(30);
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier_CollectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = HomeClassificationDetailModel.newarrayDetailShop[self.index];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    NSArray *arrayTitle = HomeClassificationDetailModel.newarrayDetailShop[self.index];
    cell.name.text = arrayTitle[indexPath.item];
    NSMutableArray *array = self.arrayViewLineData[self.index];
    [cell setModel:array[indexPath.item]];
    NSInteger typeInt = [HomeClassificationDetailModel getTypeWithTitle:arrayTitle[indexPath.item]];
    cell.selected = false;
    if ([self.model.jobId isEqualToString:@(typeInt).stringValue] && indexPath.item != arrayTitle.count - 1 && indexPath.item != arrayTitle.count - 2) {
        cell.selected = true;
    }
    NSArray *arrayEles = self.arrayDataID[self.index];
    if ([arrayEles[0] isEqualToString:self.model.jobId] && indexPath.item == array.count - 2) {
        cell.selected = true;
    }
    if ([arrayEles[1] isEqualToString:self.model.jobId] && indexPath.item == array.count - 1) {
        cell.selected = true;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayTitle = HomeClassificationDetailModel.newarrayDetailShop[self.index];
    NSInteger typeInt = [HomeClassificationDetailModel getTypeWithTitle:arrayTitle[indexPath.item]];
    NSArray *arrayID = self.arrayDataID[self.index];
    if (indexPath.item == arrayTitle.count - 2) {//其它
        typeInt = [arrayID[0] integerValue];
    }else if (indexPath.item == arrayTitle.count - 1) {//互联网+
        typeInt = [arrayID[1] integerValue];
    }
    if (self.blockDidTouchItem) {
        WorkTypeModel *model = [WorkTypeModel new];
        model.name = arrayTitle[indexPath.item];
        model.jobId = @(typeInt).stringValue;
        self.blockDidTouchItem(model);
    }
    [self.navigationController popViewControllerAnimated:true];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(Width_Layout(90), 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(Height_Layout(15), Width_Layout(15), Height_Layout(15), Width_Layout(15));
}

- (void)setSelectedValueWith:(NSInteger) index {
    [HomeClassificationDetailModel.arrayTitle enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [HomeClassificationDetailModel.arrayIsSelected replaceObjectAtIndex:idx withObject:@(0)];
        if (idx == index) {
            [HomeClassificationDetailModel.arrayIsSelected replaceObjectAtIndex:idx withObject:@(1)];
        }
    }];
}

- (void)getModelWithTitle:(WorkTypeModel *)model {
    self.model = model;
    [HomeClassificationDetailModel.newarrayDetailShop enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = obj;
        for (int i = 0; i < array.count; i ++) {
            NSString *string = array[i];
            if ([string isEqualToString:model.name] && ![string isEqualToString:@"其他"] && ![string isEqualToString:@"互联网+"]) {
                self.index = idx;
                *stop = true;
            }
        }
    }];
    if (self.index == 0) {
        [self.arrayDataID enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array = obj;
            for (int i = 0; i < array.count; i ++) {
                NSString *string = array[i];
                if ([model.jobId isEqualToString:string]) {
                    self.index = idx;
                    *stop = true;
                }
            }
        }];
    }
    [self setSelectedValueWith:self.index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
