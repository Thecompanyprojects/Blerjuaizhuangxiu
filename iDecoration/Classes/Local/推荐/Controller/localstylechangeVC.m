//
//  localstylechangeVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/11.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "localstylechangeVC.h"
#import "localstylechangeCell0.h"
#import "localstylechangeCell1.h"

@interface localstylechangeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

static NSString *stylechangeidentfid0 = @"stylechangeidentfid0";
static NSString *stylechangeidentfid1 = @"stylechangeidentfid1";

@implementation localstylechangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"风格测试";
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
        flowLayout.itemSize = CGSizeMake(kSCREEN_WIDTH, kSCREEN_HEIGHT-kNaviBottom);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_collectionView registerClass:[localstylechangeCell0 class] forCellWithReuseIdentifier:stylechangeidentfid0];
        [_collectionView registerClass:[localstylechangeCell1 class] forCellWithReuseIdentifier:stylechangeidentfid1];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = kBackgroundColor;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item==0) {
        localstylechangeCell0 *cell = (localstylechangeCell0 *)[collectionView dequeueReusableCellWithReuseIdentifier:stylechangeidentfid0 forIndexPath:indexPath];
        cell.backgroundColor = White_Color;
        [cell.submitBtn addTarget:self action:@selector(nextbtnclick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.item==1) {
        localstylechangeCell1 *cell = (localstylechangeCell1 *)[collectionView dequeueReusableCellWithReuseIdentifier:stylechangeidentfid1 forIndexPath:indexPath];
        cell.backgroundColor = White_Color;
        return cell;
    }
    return [UICollectionViewCell new];
}

-(void)nextbtnclick
{
    [self.collectionView layoutIfNeeded];
    NSIndexPath *collecIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];//偏移到某行某组
    [self.collectionView scrollToItemAtIndexPath:collecIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

 -(void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    
}

@end
