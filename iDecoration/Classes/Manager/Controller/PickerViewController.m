//
//  PickerViewController.m
//  相册中多张图片的选择
//
//  Created by guyongfeng on 16/5/4.
//  Copyright © 2016年 GYF. All rights reserved.
//

#import "PickerViewController.h"
#import "ZZPhotoPickerCell.h"
#import "ZZPhotoDatas.h"
#import "ZZPhotoListCell.h"
#import "ZZBrowserPickerViewController.h"
#import "DesignImageViewController.h"

@interface PickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,ZZBrowserPickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic ,strong) UICollectionView *picsCollection;

@property (nonatomic ,strong) NSMutableArray * photoArray;//collection的数据源

@property (nonatomic ,strong) NSMutableArray * selectArray;


@property (strong, nonatomic) UIButton *allPicTureBtn;
@property (strong, nonatomic) UIButton *previewBtn;                    //预览按钮

@property (nonatomic ,strong) NSMutableArray * previewArray; //预览的数据源


@property (strong, nonatomic) ZZPhotoDatas *datas;

@property (nonatomic ,assign) BOOL isAllPicture;

@property (nonatomic ,strong) UIView * bottomView;

@property (nonatomic ,strong) UITableView *pictureListTableView;

@property (nonatomic ,strong) NSMutableArray *listPictureArray;

@end

@implementation PickerViewController

-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

-(NSMutableArray *)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}


-(ZZPhotoDatas *)datas{
    if (!_datas) {
        _datas = [[ZZPhotoDatas alloc]init];
        _datas.type = self.imageType;
    }
    return _datas;
}


- (NSMutableArray*)listPictureArray{

    if (!_listPictureArray) {
        _listPictureArray = [NSMutableArray array];
    }
    
    return _listPictureArray;
}

- (NSMutableArray*)previewArray{

    if (!_previewArray) {
        _previewArray = [NSMutableArray array];
    }
    
    return _previewArray;
}

#pragma mark SETUP doneButtonUI Method

-(UIButton *)previewBtn{
    if (!_previewBtn) {
        _previewBtn = [[UIButton alloc]initWithFrame:CGRectMake(ZZ_VW - 60, 0, 50, 44)];
        _previewBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_previewBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [_previewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];

    }
    return _previewBtn;
}

- (void)preview{

    if (self.selectArray.count > 0) {
        
        ZZBrowserPickerViewController *browserController = [[ZZBrowserPickerViewController alloc]init];
        browserController.delegate = self;
        [browserController showIn:self animation:ShowAnimationOfPush];
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请先选择照片" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
        }];
        
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark --- ZZBrowserPickerDelegate
-(NSInteger)zzbrowserPickerPhotoNum:(ZZBrowserPickerViewController *)controller
{
    
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.selectArray.count; i++) {
        id asset = [self.selectArray objectAtIndex:i];
//        [self.datas GetImageObject:asset complection:^(UIImage *photo ,BOOL isDegradedResult) {
//            
//            if (photo){
//                [photos addObject:photo];
//            }
//            if (photos.count < self.selectArray.count){
//                return;
//            }
//            
//            self.previewArray = photos;
//        }];
        
        [photos addObject:asset];
    }
    
    self.previewArray = photos;
    
    

    return self.previewArray.count;
}

-(NSArray *)zzbrowserPickerPhotoContent:(ZZBrowserPickerViewController *)controller
{
//    NSArray *array = @[
//                       @"http://pic86.nipic.com/file/20151229/11592367_090842563000_2.jpg",
//                       [UIImage imageNamed:@"scv2.jpg"],
//                       [UIImage imageNamed:@"scv3.jpg"],
//                       [UIImage imageNamed:@"scv4.jpg"],
//                       [UIImage imageNamed:@"scv5.jpg"],
//                       ];
    return self.previewArray;
}


#pragma merk SETUP previewButtonUI Method

-(UIButton *)allPicTureBtn{
    if (!_allPicTureBtn) {
        _allPicTureBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 80, 44)];
        [_allPicTureBtn addTarget:self action:@selector(allPicTure) forControlEvents:UIControlEventTouchUpInside];
        _allPicTureBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_allPicTureBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        [_allPicTureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_allPicTureBtn setTitle:@"全部相册" forState:UIControlStateNormal];
    }
    return _allPicTureBtn;
}


- (void)allPicTure{
    
    NSMutableArray * photoListArray = [[NSMutableArray alloc]init];
    
    NSArray * allPictureArr = [self.datas GetPhotoAssets:[self.datas GetCameraRollFetchResul]];
    [photoListArray addObject:allPictureArr];
    
    NSArray * photoListArr = [self.datas GetPhotoListDatas];
    
    [photoListArray addObjectsFromArray:photoListArr];
    
    self.listPictureArray = photoListArray;
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    bottomView.backgroundColor = [UIColor clearColor];
    self.bottomView = bottomView;
    [self.view addSubview:self.bottomView];
    
    
    UIView * tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    tapView.backgroundColor = [UIColor blackColor];
    tapView.alpha = 0.5;
    [self.bottomView addSubview:tapView];
    //添加取消全部相册的手势
    UITapGestureRecognizer * cancleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleTap:)];
    [tapView addGestureRecognizer:cancleTap];
    
    UITableView *pictureListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-150) style:UITableViewStylePlain];
    pictureListTableView.dataSource = self;
    pictureListTableView.delegate = self;
    self.pictureListTableView = pictureListTableView;
    [self.bottomView addSubview:self.pictureListTableView];

   
    [self.pictureListTableView registerClass:[ZZPhotoListCell class] forCellReuseIdentifier:@"ZZPhotoListCell"];
    
    [self.pictureListTableView registerClass:[ZZPhotoListCell class] forCellReuseIdentifier:@"AllZZPhotoListCell"];
    
}


- (void)cancleTap:(UITapGestureRecognizer*)tap{

    [self.bottomView removeFromSuperview];
}

- (void)canclTap:(UITapGestureRecognizer*)tap{

}
#pragma tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.listPictureArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 0) {
        ZZPhotoListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AllZZPhotoListCell"];
        
        [cell loadAllPicture:self.listPictureArray[0]];
        
        return cell;
    }
    
    static NSString * cellD = @"ZZPhotoListCell";
    
    ZZPhotoListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellD];
    [cell loadPhotoListData:[self.listPictureArray objectAtIndex:indexPath.row]];
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        [self loadPhotoData];
        
        self.isAllPicture = NO;
       
        
    }else{
    
        self.fetch = [self.datas GetFetchResult:[self.listPictureArray objectAtIndex:indexPath.row]];
        self.photoArray = [self.datas GetPhotoAssets:self.fetch];
        
        self.isAllPicture = YES;
    }
    
     self.bottomView.hidden = YES;
    [self.picsCollection reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"相册";
    
    [self navigationUI];
    
    [self loadPhotoData];
    
    [self collectionUI];
    
    //创建底部工具栏
    [self setUpTabbar];
    
    //注册通知，让预览取消选中的
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancleChoose:) name:@"cancleChoose" object:nil];
}

- (void)cancleChoose:(NSNotification*)noti{

    NSArray * arr = noti.object;

    self.selectArray = (NSMutableArray*)arr;
    
    [self.picsCollection reloadData];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpTabbar
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = ZZ_RGB(245, 245, 245);
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:self.allPicTureBtn];
    [view addSubview:self.previewBtn];
    [self.view addSubview:view];
    
    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZZ_VW, 1)];
    viewLine.backgroundColor = ZZ_RGB(230, 230, 230);
    [view addSubview:viewLine];
    
    NSLayoutConstraint *tab_bottom = [NSLayoutConstraint constraintWithItem:_picsCollection attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *tab_width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:ZZ_VW];
    
    NSLayoutConstraint *tab_height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44];
    
    [self.view addConstraints:@[tab_bottom,tab_width,tab_height]];
    
    
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
    [editBtn addTarget:self action:@selector(rightBut) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    
}

- (void)rightBut{

    if ([self.selectArray count] == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        //[ZZPhotoHud showActiveHud];
        NSMutableArray *photos = [NSMutableArray array];
        for (int i = 0; i < self.selectArray.count; i++) {
            id asset = [self.selectArray objectAtIndex:i];
            
//            [self.datas GetImageObject:asset complection:^(UIImage *photo ,BOOL isDegradedResult) {
//                if (isDegradedResult) {
//                    return;
//                }
//                if (photo){
//                    [photos addObject:photo];
//                }
//                if (photos.count < self.selectArray.count){
//                    return;
//                }
            [photos addObject:asset];
            
                //                if (self.PhotoResult) {
                //                    self.PhotoResult(photos);
                //                }
                
                //[ZZPhotoHud hideActiveHud];
                //[self dismissViewControllerAnimated:YES completion:nil];
           
        }
        
//        ReleaseViewController * releaseVC = [[ReleaseViewController alloc]init];
//        releaseVC.PhotoResult = self.PhotoResult;
//        releaseVC.photoArray = photos;
//        [self.navigationController pushViewController:releaseVC animated:YES];
        
        DesignImageViewController *designVC = [[DesignImageViewController alloc]init];
        designVC.assetArray = photos;
        [self.navigationController pushViewController:designVC animated:YES];
    }

}

- (void)loadPhotoData{

    NSMutableArray * photoArray = [NSMutableArray array];
    
    UIImage * zXImage = [UIImage imageNamed:@"paishezhaopian"];
    
    [photoArray addObject:zXImage];
    
    NSArray * arr = [self.datas GetPhotoAssets:[self.datas GetCameraRollFetchResul]];
    [photoArray addObjectsFromArray:arr];
    
    self.photoArray = photoArray;
    
}

-(void)collectionUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    CGFloat photoSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
    flowLayout.minimumInteritemSpacing = 1.0;//item 之间的行的距离
    flowLayout.minimumLineSpacing = 1.0;//item 之间竖的距离
    flowLayout.itemSize = (CGSize){photoSize,photoSize};
    //        self.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _picsCollection = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_picsCollection registerClass:[ZZPhotoPickerCell class] forCellWithReuseIdentifier:@"PhotoPickerCell"];
    
    [_picsCollection registerClass:[ZZPhotoPickerCell class] forCellWithReuseIdentifier:@"FirstPhotoPickerCell"];
    
    flowLayout.footerReferenceSize = CGSizeMake(ZZ_VW, 70);
    _picsCollection.delegate = self;
    _picsCollection.dataSource = self;
    _picsCollection.backgroundColor = [UIColor whiteColor];
    [_picsCollection setUserInteractionEnabled:YES];
    _picsCollection.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_picsCollection];
    [_picsCollection reloadData];
    
    
    NSLayoutConstraint *pic_top = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeBottom multiplier:1 constant:44.0f];
    
    NSLayoutConstraint *pic_left = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeLeft multiplier:1 constant:0.0f];
    
    NSLayoutConstraint *pic_right = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_picsCollection attribute:NSLayoutAttributeRight multiplier:1 constant:0.0f];
    
    [self.view addConstraints:@[pic_top,pic_bottom,pic_left,pic_right]];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.isAllPicture) {
        
        if (indexPath.row == 0) {
            
            ZZPhotoPickerCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstPhotoPickerCell" forIndexPath:indexPath];
            
            photoCell.selectBtn.hidden = YES;
            photoCell.selectBtn.tag = indexPath.row;
            [photoCell loadZhaoXiangImage:self.photoArray[indexPath.row]];
            
            return photoCell;
        }
        
    }

    
    ZZPhotoPickerCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoPickerCell" forIndexPath:indexPath];
    
    
    photoCell.selectBtn.tag = indexPath.row;
    [photoCell.selectBtn addTarget:self action:@selector(selectPicBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [photoCell loadPhotoData:[self.photoArray objectAtIndex:indexPath.row]];
    [photoCell selectBtnStage:self.selectArray existence:[self.photoArray objectAtIndex:indexPath.row]];
    
    return photoCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%ld",(long)indexPath.row);
    
    if (indexPath.row == 0) {
        
        //调照相机的代码
        
        UIImagePickerController * imgPicker = [[UIImagePickerController alloc]init];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.showsCameraControls = YES;
        
         [self presentViewController:imgPicker animated:YES completion:^{}];
    }else{

        NSIndexPath * cellIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        ZZPhotoPickerCell * photoCell = (ZZPhotoPickerCell*) [collectionView cellForItemAtIndexPath:cellIndexPath];
        
        //photoCell.selectBtn.tag = indexPath.row;
        [self selectPicBtn:photoCell.selectBtn];
        
        [photoCell loadPhotoData:[self.photoArray objectAtIndex:indexPath.row]];
        [photoCell selectBtnStage:self.selectArray existence:[self.photoArray objectAtIndex:indexPath.row]];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSMutableArray * photos = [NSMutableArray array];
    [photos addObject:chooseImage];
//    
//    ReleaseViewController * releaseVC = [[ReleaseViewController alloc]init];
//    releaseVC.PhotoResult = self.PhotoResult;
//    releaseVC.photoArray = photos;
//    [self.navigationController pushViewController:releaseVC animated:YES];
//    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


- (void)selectPicBtn:(UIButton*)button{

    NSInteger index = button.tag;
    if (button.selected == NO) {
        [self shakeToShow:button];
        if (self.selectArray.count + 1 > _selectNum) {
            [self showSelectPhotoAlertView:_selectNum];
        }else{
            [self.selectArray addObject:[self.photoArray objectAtIndex:index]];
            [button setImage:Pic_Btn_Selected forState:UIControlStateNormal];
            button.selected = YES;
        }
    }else{
        [self shakeToShow:button];
        [self.selectArray removeObject:[self.photoArray objectAtIndex:index]];
        [button setImage:Pic_btn_UnSelected forState:UIControlStateNormal];
        button.selected = NO;
    }

}

-(void)showSelectPhotoAlertView:(NSInteger)photoNumOfMax
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:[NSString stringWithFormat:Alert_Max_Selected,(long)photoNumOfMax]preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark 列表中按钮点击动画效果

- (void)shakeToShow:(UIButton*)button{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
