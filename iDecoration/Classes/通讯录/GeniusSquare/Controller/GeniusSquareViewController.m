//
//  GeniusSquareViewController.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/16.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "GeniusSquareViewController.h"
#import "AddressBookCollectionViewCell0.h"
#import "GeniusSquareLabelModel.h"
#import "GeniusSquareListViewController.h"

@interface GeniusSquareViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation GeniusSquareViewController

#pragma mark UI
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部类别";
    [self createCollectionView];
}

- (void)createCollectionView {
    [self.collectionView registerNib:[UINib nibWithNibName:@"AddressBookCollectionViewCell0" bundle:nil] forCellWithReuseIdentifier:@"AddressBookCollectionViewCell0"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.itemSize = CGSizeMake(Width_Layout(100), Height_Layout(50));
}

#pragma mark collectionView
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 15, 12);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddressBookCollectionViewCell0 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddressBookCollectionViewCell0" forIndexPath:indexPath];
    GeniusSquareLabelModel *model = self.arrayData[indexPath.item];
    cell.labelTitle.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GeniusSquareListViewController *controller = [[GeniusSquareListViewController alloc] initWithNibName:@"EliteListViewController" bundle:nil];
    GeniusSquareLabelModel *model = self.arrayData[indexPath.item];
    controller.controllerTitle = model.name;
   
    [self.navigationController pushViewController:controller animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
