//
//  YPPhotosView.m
//  YPCommentDemo
//
//  Created by 朋 on 16/7/21.
//  Copyright © 2016年 杨朋. All rights reserved.
//

#import "YPPhotosView.h"
#import "YPCollectionViewCell.h"
#import "YPCollectionViewFlowLayout.h"


//#define upLoadImgWidth            720
#define upLoadImgWidth            320
#define KScreen_Size  [UIScreen mainScreen].bounds.size
#define KW (KScreen_Size.width - 8*4)/3
@interface YPPhotosView ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
YPwaterFlowLayoutDelegate,
YPCollectionViewDataSource,
YPCollectionViewDelegateFlowLayout
>
{
    
    BOOL rightBtnIsShow;//图片右上角的删除按钮是否显示（本来是不需要此值，默认是一直有的，但是后来需要加长按删除才出现按钮）
}


/***/
@property (nonatomic,weak) UIImageView *imgView;
@property (nonatomic,assign)BOOL hidden;
@end

@implementation YPPhotosView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        
        YPCollectionViewFlowLayout * layout = [[YPCollectionViewFlowLayout alloc] init];
        layout.degelate = self;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds
     collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor] ;
        _collectionView.scrollEnabled = NO;
//        _collectionView.backgroundColor = [UIColor colorWithRed:48/255.0 green:47/255.0 blue:51/255.0 alpha:1];
        // 关闭水平划线
        _collectionView.showsVerticalScrollIndicator = NO ;
        [_collectionView registerClass:[YPCollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
        [_collectionView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self addSubview:_collectionView];
        self.isShowZongAddBtn = YES;
        self.isShowDeleteBtn = YES;
    }
    return self;
}

#pragma mark - collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"CELL";
    YPCollectionViewCell *cell = (YPCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
/*让选择图片上面的delete安钮不显示*/
    
    if (!rightBtnIsShow) {
        if (_photoArray.count==1) {
            if (!_isShowDeleteBtn) {
                
                if (self.isShowZongAddBtn){
                    _hidden = YES;
                }else{
                    _hidden = NO;
                }
            }
            else{
                _hidden = YES;
            }
        }
        else{
            if (self.isShowZongAddBtn) {
                if ((indexPath.row<_photoArray.count-1)&&(!_isShowDeleteBtn)) {
                    _hidden = NO;
                }
                else{
                    _hidden = YES;
                }
            }
            else{
                if ((indexPath.row<=_photoArray.count-1)&&(!_isShowDeleteBtn)) {
                    _hidden = NO;
                }
                else{
                    _hidden = YES;
                }
            }
        }
    }
    
    else{
        if (_photoArray.count==1){
            _hidden = YES;
        }
        else{
            if (self.isShowZongAddBtn) {
                if ((indexPath.row<_photoArray.count-1)) {
                    _hidden = NO;
                }
                else{
                    _hidden = YES;
                }
            }
            else{
                if ((indexPath.row<=_photoArray.count-1)) {
                    _hidden = NO;
                }
                else{
                    _hidden = YES;
                }
            }
        }
    }
    
//    if (_photoArray.count==1 || indexPath.row == _photoArray.count-1||_isShowDeleteBtn == YES) {
//        _hidden = YES ;
//    }
//    else {
//     
//        _hidden = NO ;
//    }
//    
//    // 最后一张图片显示删除按钮
//    if (self.isShowZongAddBtn) {
//        if (indexPath.row == _photoArray.count-1) {
//            _hidden = NO;
//        }
//    }
    
    
    

    
    [cell setCellWithImageUrl:_photoArray[indexPath.row] IsFirstOrLastObjectHiddenBtn:_hidden];
    [cell.btn addTarget:self action:@selector(deleteImageClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn.tag = 2016 + indexPath.row ;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isShowZongAddBtn) {
        
        if (_photoArray.count==1) {
            if (self.clickChooseView) {
                self.clickChooseView();
            }
        }
        else{
            // 浏览大图
            if (indexPath.row < _photoArray.count-1) {
                if (self.clicklookImage) {
                    NSMutableArray *dataSourse = [NSMutableArray arrayWithArray:_photoArray];
                    [dataSourse removeLastObject];
                    NSArray *arr = dataSourse ;
                    self.clicklookImage(indexPath.row,arr);
                }
                NSLog(@"%ld",indexPath.row);
            }
            
            if (indexPath.row == _photoArray.count-1){
                if (self.clickChooseView) {
                    self.clickChooseView();
                }
            }
        }
        
    }
    else{
        if (indexPath.row <= _photoArray.count-1) {
            if (self.clicklookImage) {
                NSMutableArray *dataSourse = [NSMutableArray arrayWithArray:_photoArray];
//                [dataSourse removeLastObject];
                NSArray *arr = dataSourse ;
                self.clicklookImage(indexPath.row,arr);
            }
            NSLog(@"%ld",indexPath.row);
        }
    }
    

}



#pragma mark - 瀑布流的协议方法
- (CGFloat)YPwaterFlowLayout:(YPCollectionViewFlowLayout *)waterFlow HeightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach {
 
//    UIImage *img = _photoArray[indexPach.row];
//    return   img.size.height/img.size.width * width;
    return KW;
    
}

-(void)showRightDeleteBtn{
    if (!rightBtnIsShow) {
        rightBtnIsShow = YES;
        [_collectionView reloadData];
    }
    
    
}
#pragma mark - 删除某一张图片
- (void)deleteImageClick:(UIButton *)btn {
  
    NSMutableArray *dataSourse = [NSMutableArray arrayWithArray:_photoArray];
    [dataSourse removeObjectAtIndex:btn.tag - 2016];
    _photoArray = dataSourse ;
    if (_photoArray.count == 1) {
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    
    [_collectionView reloadData];
    
    // 回调TZImagePickerController选择器删除图片
    self.clickcloseImage(btn.tag - 2016);
    
    
}

-(void)deleteImgWithTag:(UIButton *)btn{
    // 回调TZImagePickerController选择器删除图片
    self.clickcloseImage(btn.tag);
}

-(void)addPhoto{
    if (self.clickChooseView) {
        self.clickChooseView();
    }
}

-(void)browerBigImgWithTag:(UITapGestureRecognizer *)ges{
    if (self.clicklookImage) {
        NSInteger i = ges.view.tag;
        NSMutableArray *dataSourse = [NSMutableArray arrayWithArray:_photoArray];
        if (!self.isShowAddBtn) {
            
        }
        else{
            [dataSourse removeLastObject];
        }
        
        NSArray *arr = dataSourse ;
        self.clicklookImage(i,arr);
    }
}

-(void)resetScrollView{
    [self.scrollView removeAllSubViews];
    CGFloat leftX = 8;
    for (int i = 0; i<_photoArray.count; i++) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(leftX, 4, KW, KW)];
        imgV.userInteractionEnabled = YES;
        
        id isImg = _photoArray[i];
        if ([isImg isKindOfClass:[NSString class]]) {
            NSString *str = isImg;
            [imgV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:DefaultIcon]];
        }
        
        if ([isImg isKindOfClass:[UIImage class]]) {
            UIImage *img = isImg;
            imgV.image = img;
        }
        imgV.tag = i;
        
        if (_isShowAddBtn) {
            if (i == _photoArray.count-1) {
                UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
                [imgV addGestureRecognizer:ges];
            }
            if (i<_photoArray.count-1) {
                //浏览大图
                UITapGestureRecognizer *gesTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerBigImgWithTag:)];
                
                [imgV addGestureRecognizer:gesTwo];
                
            }
        }
        else{
            if (i<_photoArray.count) {
                //浏览大图
                UITapGestureRecognizer *gesTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerBigImgWithTag:)];
                
                [imgV addGestureRecognizer:gesTwo];

            }
        }
        
        
        [self.scrollView addSubview:imgV];
        
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(leftX+KW-20, 0, 30, 30);
        deleteBtn.layer.masksToBounds = YES;
        deleteBtn.layer.cornerRadius = deleteBtn.width/2;
//        _addBtn.layer.borderWidth = 1.0;
//        _addBtn.layer.borderColor = COLOR_BLACK_CLASS_9.CGColor;
        //            _addressBtn.backgroundColor = Red_Color;
        [deleteBtn setImage:[UIImage imageNamed:@"del02"] forState:UIControlStateNormal];
        if (i == _photoArray.count-1) {
            deleteBtn.hidden = YES;
        }else{
            if (!self.isShowScrDeleteBtn) {
                deleteBtn.hidden = YES;
            }
            else{
                deleteBtn.hidden = NO;
            }
            
        }
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(deleteImgWithTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:deleteBtn];
        leftX = leftX + (8+KW);
    }
}

#pragma mark - 外部API 选择图片完成是调用
- (void)setYPPhotosView:(NSArray *)photoArray {
    if (photoArray.count > 1) {
//        _collectionView.backgroundColor = [UIColor colorWithRed:48/255.0 green:47/255.0 blue:51/255.0 alpha:1];
        _collectionView.backgroundColor = White_Color;
    }
   
    _photoArray = photoArray ;
    if (self.isRow) {
        self.collectionView.hidden = YES;
        self.scrollView.hidden = NO;
        [self addSubview:self.scrollView];
        [self resetScrollView];
    }
    else{
        self.collectionView.hidden = NO;
        self.scrollView.hidden = YES;
        [_collectionView reloadData];
    }
    
}

-(UIScrollView *)scrollView{
    if (!_scrollView ) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    }
    return _scrollView;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
//    ZCHGoodsShowModel *playingCard = self.dataArr[fromIndexPath.item];
//
//    [self.dataArr removeObjectAtIndex:fromIndexPath.item];
//    [self.dataArr insertObject:playingCard atIndex:toIndexPath.item];
//    if (self.changeImage) {
//        self.changeImage(fromIndexPath, toIndexPath);
//    }
//    if (self.changeImage) {
//        self.changeImage(fromIndexPath, toIndexPath);
//    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{

    if (self.changeImage) {
        self.changeImage(fromIndexPath, toIndexPath);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.item==_photoArray.count-1) {
        return NO;
    }
    else{
        return YES;
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    if (toIndexPath.item==_photoArray.count-1) {
        return NO;
    }
    else{
        return YES;
    }
    
}

@end
