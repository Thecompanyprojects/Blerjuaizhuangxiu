//
//  PopupsView.m
//  Popups
//
//  Created by Arthur on 2018/5/30.
//  Copyright © 2018年 Arthur. All rights reserved.
//

#import "PopupsViewDelegate.h"
#import "newpopviewCell.h"
#import "AdviserList.h"

#define fDeviceWidth 265
#define fDeviceHeight 285


@interface PopupsViewDelegate()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,popDelegate>
@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UIImageView *rightImg;


@end

@implementation PopupsViewDelegate


- (instancetype)initWithImage:(NSString *)imageName {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    
        self.alertView.frame = CGRectMake(0, 0, 265, 285);
        self.alertView.center = self.center;
        [self addSubview:self.alertView];
        
        [self.alertView addSubview:self.collectionView];
        [self addSubview:self.leftImg];
        [self addSubview:self.rightImg];
        [self setuplayout];
    }
    
    return self;
}

-(void)setuplayout
{
    __weak typeof (self) weakSelf = self;
    [weakSelf.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(13);
        make.height.mas_offset(15);
        make.right.equalTo(weakSelf.alertView.mas_left).with.offset(-8);
        make.centerY.equalTo(weakSelf);
    }];
    [weakSelf.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(13);
        make.height.mas_offset(15);
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf.alertView.mas_right).with.offset(8);
    }];
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 12;
        _alertView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenAction)];
        [_alertView addGestureRecognizer:tap];
    }
    return _alertView;
}

- (void)showView {
    self.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    
    self.alertView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    self.alertView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4f];
        self.alertView.transform = transform;
        self.alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hiddenAction {
    if ([_delegate respondsToSelector:@selector(didSelectedCancel:withImageName:)]) {
//        [_delegate didSelectedCancel:self withImageName:[self.alertView accessibilityIdentifier]];
        
    }
}


-(void)dismissAlertView {
    [UIView animateWithDuration:.2 animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.08
                         animations:^{
                             self.alertView.transform = CGAffineTransformMakeScale(0.25, 0.25);
                         }completion:^(BOOL finish){
                             [self removeFromSuperview];
                         }];
    }];
}

#pragma mark - 创建collectionView并设置代理
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, fDeviceWidth, fDeviceHeight) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
      
        flowLayout.itemSize = CGSizeMake(fDeviceWidth, fDeviceHeight);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView.showsHorizontalScrollIndicator=YES;
        [_collectionView registerClass:[newpopviewCell class] forCellWithReuseIdentifier:@"newpopviewCell"];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        //背景颜色
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 0;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


-(UIImageView *)leftImg
{
    if(!_leftImg)
    {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.image = [UIImage imageNamed:@"icon_zuohua"];
    }
    return _leftImg;
}

-(UIImageView *)rightImg
{
    if(!_rightImg)
    {
        _rightImg = [[UIImageView alloc] init];
        _rightImg.image = [UIImage imageNamed:@"icon_youhua"];
    }
    return _rightImg;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count?:0;
}

#pragma mark 每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"newpopviewCell";
    newpopviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    [cell setdata:self.dataSource[indexPath.item]];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    return cell;
}

#pragma mark - popDelegate

-(void)phoneTabVClick:(UICollectionViewCell *)cell
{
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSInteger index = indexpath.item;
   // [self phoneclick:index];
    [self.delegate phoneclick:index];
}
-(void)wxTabVClick:(UICollectionViewCell *)cell
{
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSInteger index = indexpath.item;
    //[self wxclick:index];
    [self.delegate wxclick:index];
}
-(void)qqTabVClick:(UICollectionViewCell *)cell
{
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    NSInteger index = indexpath.item;
   // [self qqclick:index];
    [self.delegate qqclick:index];
}

#pragma mark - 协议方法



@end
