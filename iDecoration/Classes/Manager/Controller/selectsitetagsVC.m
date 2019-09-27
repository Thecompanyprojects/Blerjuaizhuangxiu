//
//  selectsitetagsVC.m
//  iDecoration
//
//  Created by 王俊钢 on 2018/9/26.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "selectsitetagsVC.h"
#import "localgoodstypeCell.h"
#import "localgoodstypeHeaderView.h"

static NSString *selectsitetagsidentfid = @"selectsitetagsidentfid";

@interface selectsitetagsVC()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL choose0;
    BOOL choose1;
    BOOL choose2;
    BOOL choose3;
    BOOL choose4;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *arr0;
@property (nonatomic,strong) NSArray *arr1;
@property (nonatomic,strong) NSArray *arr2;
@property (nonatomic,strong) NSArray *arr3;
@property (nonatomic,strong) NSArray *arr4;
@property (nonatomic,strong) NSMutableArray *chooseArray;
@end

@implementation selectsitetagsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏最右侧的按钮
    UIButton *moreBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    moreBtn.frame = CGRectMake(0, 0, 44, 44);
    [moreBtn setTitle:@"完成" forState:normal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [moreBtn setTitleColor:White_Color forState:normal];
    [moreBtn addTarget:self action:@selector(finishbtnclick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    self.title = @"选择标签";
    
    self.chooseArray = [NSMutableArray array];
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - getters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        // CGFloat naviBottom = kSCREEN_HEIGHT-(self.navigationController.navigationBar.bottom);
       // CGFloat naviBottom = kSCREEN_HEIGHT-52;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT) collectionViewLayout:flowLayout];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(80, 41);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 1;
        [_collectionView registerClass:[localgoodstypeCell class] forCellWithReuseIdentifier:selectsitetagsidentfid];
        flowLayout.sectionInset =UIEdgeInsetsMake(10,7, 7, 7);
        
        flowLayout.headerReferenceSize =CGSizeMake(kSCREEN_WIDTH,27);//头视图大小
        [_collectionView registerClass:[localgoodstypeHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.allowsMultipleSelection = YES;
        
        
        
        

    }
    return _collectionView;
}

-(NSArray *)arr0
{
    if(!_arr0)
    {
        _arr0 = [NSArray arrayWithObjects:@"现代风格",@"简约风格",@"欧式风格",@"中式风格",@"美式风格",@"地中海风格",@"东南亚风格",@"日式风格", nil];
    }
    return _arr0;
}

-(NSArray *)arr1
{
    if(!_arr1)
    {
        _arr1 = [NSArray arrayWithObjects:@"一居",@"两居",@"三居",@"四居",@"复式",@"阔楼",@"别墅", nil];
        
    }
    return _arr1;
}

-(NSArray *)arr2
{
    if(!_arr2)
    {
        _arr2 = [NSArray arrayWithObjects:@"5万以下",@"5-10万",@"10-20万",@"20-30万",@"30万以上", nil];
        
    }
    return _arr2;
}

-(NSArray *)arr3
{
    if(!_arr3)
    {
        _arr3 = [NSArray arrayWithObjects:@"水瓶座",@"双鱼座",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座", nil];
        
    }
    return _arr3;
}

-(NSArray *)arr4
{
    if(!_arr4)
    {
        _arr4 = [NSArray arrayWithObjects:@"完美型",@"助人型",@"事业型",@"自我型",@"理智型",@"疑惑型",@"活跃型",@"领袖型",@"和平型", nil];
        
    }
    return _arr4;
}

#pragma mark -UICollectionViewDataSource&&UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.arr0.count?:0;
            break;
        case 1:
            return self.arr1.count?:0;
            break;
        case 2:
            return self.arr2.count?:0;
            break;
        case 3:
            return self.arr3.count?:0;
            break;
        case 4:
            return self.arr4.count?:0;
            break;
        default:
            break;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    localgoodstypeCell *cell = (localgoodstypeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:selectsitetagsidentfid forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLab.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    
    switch (indexPath.section) {
        case 0:
            cell.nameLab.text = self.arr0[indexPath.item];
            break;
        case 1:
            cell.nameLab.text = self.arr1[indexPath.item];
            break;
        case 2:
            cell.nameLab.text = self.arr2[indexPath.item];
            break;
        case 3:
            cell.nameLab.text = self.arr3[indexPath.item];
            break;
        case 4:
            cell.nameLab.text = self.arr4[indexPath.item];
            break;
        default:
            break;
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    localgoodstypeHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            header.typeLab.text = @"装修风格";
            break;
        case 1:
            header.typeLab.text = @"户型格局";
            break;
        case 2:
            header.typeLab.text = @"装修预算";
            break;
        case 3:
            header.typeLab.text = @"十二星座";
            break;
        case 4:
            header.typeLab.text = @"九型人格";
            break;
        default:
            break;
    }
    return header;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 27);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    localgoodstypeCell*cell = (localgoodstypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
   
  
    if (indexPath.section==0) {
        if (choose0==NO) {
            choose0 = YES;
            cell.nameLab.backgroundColor = Main_Color;
            NSString *str = self.arr0[indexPath.item];
            [self.chooseArray addObject:str];
        }
    
        
    }
    if (indexPath.section==1) {
        if (choose1==NO) {
            choose1 = YES;
            cell.nameLab.backgroundColor = Main_Color;
            NSString *str = self.arr1[indexPath.item];
            [self.chooseArray addObject:str];
        }
       
    }
    if (indexPath.section==2) {
        if (choose2==NO) {
            choose2 = YES;
            cell.nameLab.backgroundColor = Main_Color;
            NSString *str = self.arr2[indexPath.item];
            [self.chooseArray addObject:str];
        }
       
    }
    if (indexPath.section==3) {
        if (choose3==NO) {
            choose3 = YES;
            cell.nameLab.backgroundColor = Main_Color;
            NSString *str = self.arr3[indexPath.item];
            [self.chooseArray addObject:str];
        }
     
    }
    if (indexPath.section==4) {
        if (choose4==NO) {
            choose4 = YES;
            cell.nameLab.backgroundColor = Main_Color;
            NSString *str = self.arr4[indexPath.item];
            [self.chooseArray addObject:str];
        }
       
    }
    
}

//取消选定

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    localgoodstypeCell *cell = (localgoodstypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.nameLab.backgroundColor = [UIColor hexStringToColor:@"F2F2F2"];
    //cell.layer.borderColor = [UIColor hexStringToColor:@"EEEEEE"].CGColor;
    // NSLog(@"1第%ld区，1第%ld个",(long)indexPath.section,(long)indexPath.row);
    // [self cancel];
    if (indexPath.section==0) {
        choose0 = NO;
        NSString *str = self.arr0[indexPath.item];
        [self.chooseArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:str]) {
                [self.chooseArray removeObject:obj];
            }
        }];
        

    }
    if (indexPath.section==1) {
        choose1 = NO;
        NSString *str = self.arr1[indexPath.item];
        [self.chooseArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:str]) {
                [self.chooseArray removeObject:obj];
            }
        }];
    }
    if (indexPath.section==2) {
        choose2 = NO;
        NSString *str = self.arr2[indexPath.item];
        [self.chooseArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:str]) {
                [self.chooseArray removeObject:obj];
            }
        }];
    }
    if (indexPath.section==3) {
        choose3 = NO;
        NSString *str = self.arr3[indexPath.item];
        [self.chooseArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:str]) {
                [self.chooseArray removeObject:obj];
            }
        }];
    }
    if (indexPath.section==4) {
        choose4 = NO;
        NSString *str = self.arr4[indexPath.item];
        [self.chooseArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:str]) {
                [self.chooseArray removeObject:obj];
            }
        }];
    }
}

-(void)finishbtnclick
{
    [self.delegate myTabVClick:self.chooseArray];
    [self.navigationController popViewControllerAnimated:YES];
}

//设置点击高亮和非高亮效果！
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
