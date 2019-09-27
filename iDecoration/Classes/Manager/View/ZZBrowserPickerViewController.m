//
//  ZZBrowserPickerViewController.m
//  ZZFramework
//
//  Created by Yuan on 15/12/23.
//  Copyright © 2015年 zzl. All rights reserved.
//

#import "ZZBrowserPickerViewController.h"
#import "ZZBrowserPickerCell.h"
#import "ZZBrowerAnimate.h"
#import "ZZPageControl.h"

@interface ZZBrowserPickerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *picBrowse;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *photoDataArray;
@property (nonatomic, strong) ZZBrowerAnimate *animate;
@property (nonatomic, strong) ZZPageControl *pageControl;

@property (nonatomic ,strong) UIButton * rightBarBut;

//照片的总数
@property (nonatomic, assign) NSInteger numberOfItems;

@property (nonatomic, assign) BOOL isOK;//控制导航栏的显隐

@property (nonatomic ,strong) UIView * bottomView;
@property (nonatomic ,strong) UIButton * chooseBut;
@property (nonatomic ,strong) NSMutableArray *chooseArray;
@property (nonatomic, assign) BOOL isSelected;//控制导航栏的显隐

@end

@implementation ZZBrowserPickerViewController

- (NSMutableArray*)chooseArray{

    if (!_chooseArray) {
        _chooseArray = [NSMutableArray array];
        
        for (int i = 0 ; i < self.photoDataArray.count; i++) {
            
            [_chooseArray addObject:@YES];
        }
    }
    
    return _chooseArray;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
   
    self.rightBarBut.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.rightBarBut.hidden = YES;
}


- (void)navigationUI{

    // 设置导航栏最右侧的按钮
    UIButton *editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    editBtn.frame = CGRectMake(0, 0, 44, 44);
    [editBtn setTitle:@"完成" forState:UIControlStateNormal];
    [editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    editBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    editBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [editBtn addTarget:self action:@selector(rightBarBut:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
//    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarBut)];
//    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    // 设置导航栏最左侧的按钮
    UIButton *fanhuiBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    fanhuiBtn.frame = CGRectMake(0, 0, 44, 44);
    [fanhuiBtn setTitle:@"返回" forState:UIControlStateNormal];
    [fanhuiBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    //    editBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    fanhuiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    fanhuiBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    fanhuiBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [fanhuiBtn addTarget:self action:@selector(leftBarBut) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:fanhuiBtn];
}

- (void)rightBarBut:(UIButton*)sender{

    NSMutableArray * numberArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.chooseArray.count; i++) {
        
        bool isOK = [self.chooseArray[i] boolValue];
        
        if (isOK) {
            
            PHAsset * asset = self.photoDataArray[i];
            
            [numberArray addObject:asset];
        }
        
    }

//    ReleaseViewController * releaseVC = [[ReleaseViewController alloc]init];
//    releaseVC.photoArray = numberArray;
//    [self.navigationController pushViewController:releaseVC animated:YES];
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs removeObject:self];
    self.navigationController.viewControllers = vcs;
    
    
}

- (void)leftBarBut{
    
    NSMutableArray * numberArray = [NSMutableArray array];
    
    for (int i = 0 ; i < self.chooseArray.count; i++) {
        
        bool isOK = [self.chooseArray[i] boolValue];
        
        if (isOK) {
            
             PHAsset * asset = self.photoDataArray[i];
            
            [numberArray addObject:asset];
        }
        
    }
    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancleChoose" object:numberArray];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupCollectionViewUI
{
    
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.itemSize = (CGSize){self.view.frame.size.width,self.view.frame.size.height - 64};
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _picBrowse = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:_flowLayout];
    _picBrowse.backgroundColor = [UIColor clearColor];
    _picBrowse.pagingEnabled = YES;
    _picBrowse.scrollEnabled = YES;
    _picBrowse.showsHorizontalScrollIndicator = NO;
    _picBrowse.showsVerticalScrollIndicator = NO;
    [_picBrowse registerClass:[ZZBrowserPickerCell class] forCellWithReuseIdentifier:@"Cell"];
    _picBrowse.dataSource = self;
    _picBrowse.delegate = self;
    
    if (self.indexPath != nil) {
        [_picBrowse scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    [self.view addSubview:_picBrowse];
}

-(void)setPageControlUI
{
    /*
     *   创建底部PageControl（自定义）
     */
    _pageControl = [[ZZPageControl alloc]initWithFrame:CGRectMake(0, kSCREEN_HEIGHT - 64, kSCREEN_WIDTH, 64)];
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.403];
    _pageControl.pageControl.textColor = [UIColor whiteColor];
    [self.view addSubview:_pageControl];
    
    //照片总数通过delegate获取
    _numberOfItems = [self.delegate zzbrowserPickerPhotoNum:self];

    //判断是否需要滚动到指定图片
    if (self.indexPath != nil) {
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%ld / %ld",(long)self.indexPath.row + 1,(long)_numberOfItems];
    }else{
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",1,(long)_numberOfItems];
    }
    
    UIButton * chooseBut = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBut.frame = CGRectMake(250, 15, 50, 40);
    
    [chooseBut setImage:Pic_Btn_Selected forState:UIControlStateNormal];
            
    [chooseBut addTarget:self action:@selector(chooseBut:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseBut = chooseBut;
    [_pageControl addSubview:self.chooseBut];
    
}

-(NSMutableArray *)photoDataArray{
    if (!_photoDataArray) {
        _photoDataArray = [NSMutableArray array];
    }
    return _photoDataArray;
}



- (void)chooseBut:(UIButton*)sender{

    BOOL isSelected = [self.chooseArray[self.pageControl.currentPage] boolValue];
    
    if (isSelected) {
        
        [self.chooseBut setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
        
    }else{
        [self.chooseBut setImage:Pic_Btn_Selected forState:UIControlStateNormal];
        
    }
    
    NSNumber * selected = [NSNumber numberWithBool:!isSelected];
    
    self.chooseArray[self.pageControl.currentPage] = selected;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     *   创建核心内容 UICollectionView
     */
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self navigationUI];
    
    [self setupCollectionViewUI];
    
    
    
    [self setPageControlUI];
    
   
     [self loadPhotoData];

}

-(void)loadPhotoData
{
    if ([self.delegate respondsToSelector:@selector(zzbrowserPickerPhotoContent:)]) {
        [self.photoDataArray addObjectsFromArray:[self.delegate zzbrowserPickerPhotoContent:self]];
    }
}

/*
 *   更新数据刷新方法
 */

-(void)reloadData
{
    
    [_picBrowse reloadData];
    //照片总数通过delegate获取
    if ([self.delegate respondsToSelector:@selector(zzbrowserPickerPhotoNum:)]) {
        _numberOfItems = [self.delegate zzbrowserPickerPhotoNum:self];
    }

    //判断是否需要滚动到指定图片
    if (self.indexPath != nil) {
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%ld / %ld",(long)self.indexPath.row + 1,(long)_numberOfItems];
    }else{
        _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",1,(long)_numberOfItems];
    }
}

#pragma mark --- UICollectionviewDelegate or dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.delegate zzbrowserPickerPhotoNum:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZZBrowserPickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
   

    if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[PHAsset class]]) {
        //加载相册中的数据时实用
        PHAsset *assetItem = [_photoDataArray objectAtIndex:indexPath.row];
        [cell loadPHAssetItemForPics:assetItem];
    }else if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]){
        //加载网络中的图片数据，图片地址使用
        
        [cell.pics sd_setImageWithURL:[NSURL URLWithString:[_photoDataArray objectAtIndex:indexPath.row]]];
    
    }else if ([[_photoDataArray objectAtIndex:indexPath.row] isKindOfClass:[UIImage class]]){
        //加载 UIImage 类型的数据
        cell.pics.image = [_photoDataArray objectAtIndex:indexPath.row];
    }
    
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)index
{
    if (self.showAnimation == ShowAnimationOfPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.isOK) {
        
        //self.navigationController.navigationBarHidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.navigationController.navigationBarHidden = NO;
            _pageControl.hidden = NO;
        } completion:^(BOOL finished) {
            
            
        }];
        self.isOK = NO;
    }else{
    
        [UIView animateWithDuration:0.5 animations:^{
            
            self.navigationController.navigationBarHidden = YES;
            _pageControl.hidden = YES;

        } completion:^(BOOL finished) {
            
           
        }];

        
        self.isOK = YES;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int itemIndex = (scrollView.contentOffset.x + self.picBrowse.frame.size.width * 0.5) / self.picBrowse.frame.size.width;
    if (!self.numberOfItems) return;
    int indexOnPageControl = itemIndex % self.numberOfItems;
    
    _pageControl.pageControl.text = [NSString stringWithFormat:@"%d / %ld",indexOnPageControl+1,(long)_numberOfItems];
    self.pageControl.currentPage = indexOnPageControl;
    
    
    BOOL isSelected = [self.chooseArray[indexOnPageControl] boolValue];
    
    if (isSelected) {
        
        [self.chooseBut setImage:Pic_Btn_Selected forState:UIControlStateNormal];
        
    }else{
    
        [self.chooseBut setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
    }
}

-(void)showIn:(UIViewController *)controller animation:(ShowAnimation)animation
{
    if (animation == ShowAnimationOfPush) {
        
        if (_isOpenAnimation == NO) {
            [controller.navigationController pushViewController:self animated:YES];
        }else{
            controller.navigationController.delegate = self;
            
            _animate = [ZZBrowerAnimate new];
            _animate.style = PushAnimate;
            [controller.navigationController pushViewController:self animated:YES];
        }
        
    }else if (animation == ShowAnimationOfPresent){
        if (_isOpenAnimation == NO) {
            self.showAnimation = ShowAnimationOfPresent;
            [controller presentViewController:self animated:YES completion:nil];
        }else{
            self.showAnimation = ShowAnimationOfPresent;
            //设置动画效果
            self.transitioningDelegate = self;
            _animate = [ZZBrowerAnimate new];
            _animate.style = PushAnimate;
            
            [controller presentViewController:self animated:YES completion:nil];
        }
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return self.animate;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.animate;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.animate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
