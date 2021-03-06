//
//  JFCityTableViewCell.m
//  JFFootball
//
//  Created by 张志峰 on 2016/11/21.
//  Copyright © 2016年 zhifenx. All rights reserved.
//

#import "JFCityTableViewCell.h"

#import "Masonry.h"
#import "JFCityCollectionFlowLayout.h"
#import "JFCityCollectionViewCell.h"
#import "ZCHCityModel.h"

#define JFRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

NSString * const JFCityTableViewCellDidChangeCityNotification = @"JFCityTableViewCellDidChangeCityNotification";

static NSString *ID = @"cityCollectionViewCell";

@interface JFCityTableViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JFCityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = JFRGBColor(247, 247, 247);;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[[JFCityCollectionFlowLayout alloc] init]];
        [_collectionView registerClass:[JFCityCollectionViewCell class] forCellWithReuseIdentifier:ID];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = JFRGBColor(247, 247, 247);
    }
    return _collectionView;
}

- (void)setCityNameArray:(NSArray *)cityNameArray {
    
    _cityNameArray = cityNameArray;
    _collectionView.frame = CGRectMake(0, 5, BLEJWidth, (cityNameArray.count / 3 + (cityNameArray.count % 3 > 0 ? 1 : 0)) * 50);
    [_collectionView reloadData];
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cityNameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JFCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.title = ((ZCHCityModel *)_cityNameArray[indexPath.row]).name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHCityModel *model = (ZCHCityModel *)_cityNameArray[indexPath.row];
    NSDictionary *dic = @{
                          @"tableView" : self.indexPath,
                          @"collectionView" : indexPath,
                          @"model" : model
                          };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JFCityTableViewCellDidChangeCityNotification object:nil userInfo:dic];
}


@end
