//
//  AddressBookTableViewCell.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookTableViewCell.h"
#import "AddressBookCollectionViewCell0.h"
#import "AddressBookCollectionViewCell1.h"
#import "AddressBookCollectionViewCell2.h"
#import "AddressBookCollectionViewCell3.h"
#import "GeniusSquareLabelModel.h"

@implementation AddressBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    [self.buttonAll setTitle:@"更 多" forState:(UIControlStateNormal)];
    self.buttonAll.hidden = false;
}

- (void)reloadDataWithArray:(NSMutableArray *)array AndIndex:(NSInteger)index {
    self.arrayData = [array mutableCopy];
    self.index = index;
    self.collectionView.scrollEnabled = false;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
    if(index == 3) {
        [self.collectionView registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"AddressBookCollectionViewCell1"] bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"AddressBookCollectionViewCell1"]];
    }else{
        [self.collectionView registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"AddressBookCollectionViewCell%ld",(long)index] bundle:nil] forCellWithReuseIdentifier:[NSString stringWithFormat:@"AddressBookCollectionViewCell%ld",(long)index]];
    }

    if (index == 0) {//人才广场
        self.buttonAll.hidden = false;
        self.flowLayout.itemSize = CGSizeMake(Width_Layout(60), Height_Layout(40));
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }else if (index == 1 || index == 3) {//精英推荐 || 名人专访
        self.buttonAll.hidden = false;
        self.flowLayout.itemSize = CGSizeMake(Width_Layout(295), 340);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.minimumLineSpacing = 10;
        self.flowLayout.minimumInteritemSpacing = 10;
        self.collectionView.scrollEnabled = false;
    }else if (index == 2) {
        self.buttonAll.hidden = true;
        self.flowLayout.itemSize = CGSizeMake(Width_Layout(130), 65);
        self.flowLayout.minimumLineSpacing = Width_Layout(48);
        self.flowLayout.minimumInteritemSpacing = 8;
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.index == 1 || self.index == 3) {
        return 1;
    }
    return self.arrayData.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.index == 1 || self.index == 3) {
        return UIEdgeInsetsMake(0, Width_Layout(37), 0, Width_Layout(37));
    }else if (self.index == 2) {
        return UIEdgeInsetsMake(0, Width_Layout(31), 15, Width_Layout(31));
    }
    return UIEdgeInsetsMake(0, 12, 15, 12);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cellNil = [UICollectionViewCell new];
    if (self.index == 0) {
        AddressBookCollectionViewCell0 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddressBookCollectionViewCell0" forIndexPath:indexPath];
        GeniusSquareLabelModel *model = self.arrayData[indexPath.item];
        cell.labelTitle.text = model.name;
        return cell;
    }else if (self.index == 1) {//精英推荐
        AddressBookCollectionViewCell1 *cell = [self makeCellWithCollectionView:collectionView AndIndexPath:indexPath];
        return cell;
    }else if (self.index == 2) {
        AddressBookCollectionViewCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddressBookCollectionViewCell2" forIndexPath:indexPath];
        if (indexPath.item == 0) {
            [cell.imageViewIcon setImage:[UIImage imageNamed:@"img_hr_nol"]];
        }else{
            [cell.imageViewIcon setImage:[UIImage imageNamed:@"img_hmd_nol"]];
        }
        return cell;
    }else if (self.index == 3) {//名人专访
        AddressBookCollectionViewCell1 *cell = [self makeCellWithCollectionView:collectionView AndIndexPath:indexPath];
        return cell;
    }
    return cellNil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.index) {
        case 0: {
            GeniusSquareLabelModel *model = self.arrayData[indexPath.item];
            if (self.blockDidTouchItem) {
                self.blockDidTouchItem(model.name);
            }
        }
            break;
        case 1:

            break;
        case 2:
            if (self.blockDidTouchItem) {
                self.blockDidTouchItem(self.arrayData[indexPath.item]);
            }
            break;
        case 3:

            break;
        default:
            break;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"AddressBookTableViewCell";
    AddressBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UIAccessibilityTraitNone;
    return cell;
}

- (IBAction)didTouchButtonAll:(UIButton *)sender {
    if (self.blockDidTouchButtonAll) {
        self.blockDidTouchButtonAll();
    }
}

- (AddressBookCollectionViewCell1 *)makeCellWithCollectionView:(UICollectionView *)collectionView AndIndexPath:(NSIndexPath *)indexPath {
    AddressBookCollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddressBookCollectionViewCell1" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor hexStringToColor:@"eeeeee"].CGColor;
    cell.layer.borderWidth = 1.0f;
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = 2;
    imageView.clipsToBounds = true;
    if (self.index == 1) {
        [imageView setImage:[UIImage imageNamed:@"img_jy"]];
    }else if (self.index == 3) {
        [imageView setImage:[UIImage imageNamed:@"img_mr"]];
    }
    [imageView setNeedsUpdateConstraints];
    [imageView updateConstraintsIfNeeded];
    CGRect newFrame = imageView.frame;
    newFrame.size.height = 80;
    imageView.frame = newFrame;
    [imageView setNeedsLayout];
    [imageView layoutIfNeeded];
    [cell.tableView setTableHeaderView:imageView];
    cell.arrayData = self.arrayData;
    [cell.tableView reloadData];
    cell.blockDidtouchCell = ^(GeniusSquareListModel *model) {
        if (self.blockDidTouchTableViewCell) {
            self.blockDidTouchTableViewCell(model);
        }
    };
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
