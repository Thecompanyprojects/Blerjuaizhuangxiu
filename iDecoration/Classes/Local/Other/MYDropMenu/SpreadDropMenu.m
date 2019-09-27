//
//  SpreadDropMenu.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/8/27.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "SpreadDropMenu.h"
#import "spreadmenuCell.h"

@interface SpreadDropMenu ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation SpreadDropMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.clearBack = NO;
    self.dataSource = [NSMutableArray array];
    [self.dataSource addObject:@"不限"];
    [self.dataSource addObject:@"业主评价"];
    [self.dataSource addObject:@"最新发布"];
    [self.dataSource addObject:@"收藏最多"];
    self.view.backgroundColor = White_Color;
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
 
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bottom-5, kSCREEN_WIDTH, naviBottom-5) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(78, 28);
        flowLayout.sectionInset = UIEdgeInsetsMake(34, 18, 10, 34);
        [_collectionView registerClass:[spreadmenuCell class] forCellWithReuseIdentifier:@"UICollectionViewCellidentfid"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = White_Color;
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _collectionView;
}

#pragma mark -UICollectionViewDataSource&&UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    spreadmenuCell *cell = (spreadmenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCellidentfid" forIndexPath:indexPath];
    //cell.backgroundColor = Green_Color;
    cell.typeLab.text = self.dataSource[indexPath.item];
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor hexStringToColor:@"EEEEEE"].CGColor;
    cell.layer.cornerRadius = 3;
    return cell;
}

////这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 16;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 32;
}

//点击选定

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    spreadmenuCell*cell = (spreadmenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor hexStringToColor:@"25B764"].CGColor;
    //NSLog(@"第%ld区，第%ld个",(long)indexPath.section,(long)indexPath.row);
    //[self makeSure];
    [self.delegate myTabVClick:indexPath.item];
}

//取消选定

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    spreadmenuCell *cell = (spreadmenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor hexStringToColor:@"EEEEEE"].CGColor;
   // NSLog(@"1第%ld区，1第%ld个",(long)indexPath.section,(long)indexPath.row);
   // [self cancel];
   
}


- (void)makeSure
{
    if (self.callback) {
        self.callback(@"点击了确定");
    }
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}

- (void)cancel
{
    if (self.callback) {
        self.callback(@"点击了取消");
    }
    [self dismissViewControllerAnimated:YES completion:nil];   //菜单消失
}

@end
