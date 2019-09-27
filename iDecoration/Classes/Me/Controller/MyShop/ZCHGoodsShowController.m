//
//  ZCHGoodsShowController.m
//  iDecoration
//
//  Created by 赵春浩 on 17/5/25.
//  Copyright © 2017年 RealSeven. All rights reserved.
//

#import "ZCHGoodsShowController.h"
#import "ZCHGoodsShowCollectionViewCell.h"
#import "ZCHGoodsShowModel.h"
#import "EditShopDetailController.h"
//#import "ZCHGoodsDetailController.h"
#import "EditShopDetailVC.h"
#import "ZCHGoodsDetailViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"

static NSString *reuseIdentifier = @"ZCHGoodsShowCollectionViewCell";
@interface ZCHGoodsShowController ()<LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (assign, nonatomic) BOOL isShowDelete;
@property (strong, nonatomic) ZCHGoodsShowCollectionViewCell *myCell;
@property (strong, nonatomic) NSIndexPath *myIndexPath;
@property (strong, nonatomic) UIButton *addBtn;

@end

@implementation ZCHGoodsShowController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = White_Color;
    self.title = @"商品管理";
    self.isShowDelete = NO;
    self.dataArr = [NSMutableArray array];
    // 单独处理这里的返回按钮(因为需要返回到根控制器)
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    [self setUpUI];
    [self setData];
}

- (void)back {
    
    if (self.isShowDelete) {
        
        [self.collectionView reloadData];
        self.isShowDelete = NO;
        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
//        [self.collectionView addGestureRecognizer:self.longPress];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - request
- (void)setData {
    
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandies/list.do"];
    UserInfoModel *model = [[PublicTool defaultTool] publicToolsGetUserInfoModelFromDict];
    NSDictionary *paramDic = @{@"merchantId" : self.merchantNo,
                               @"agencysId": @(model.agencyId),
                               @"type": @(0)};
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [self.dataArr removeAllObjects];
        // 1000 有商品 1001 没有商品
        if (responseObj) {
            if ([responseObj[@"code"] integerValue] == 1000) {
                
                [self.dataArr addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ZCHGoodsShowModel class] json:responseObj[@"list"]]];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"按住图片拖拽可调整顺序"];
            }
            if ([responseObj[@"code"] integerValue] == 1001) {
                
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"暂无商品"];
            }
        }
        
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}

- (void)setUpUI {
    
    LXReorderableCollectionViewFlowLayout *layout = [[LXReorderableCollectionViewFlowLayout alloc] init];
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(BLEJWidth * 1/3, BLEJWidth * 1/3 + 50);
    // 行间距
    layout.minimumLineSpacing = 10;
    // 左右间距
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 69, BLEJWidth, BLEJHeight - 69) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = White_Color;
    [self.view addSubview:self.collectionView];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZCHGoodsShowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didClickIconView:)];
//    longPress.minimumPressDuration = 0.5;
//    self.longPress = longPress;
//    longPress.delegate = self;
//    [self.collectionView addGestureRecognizer:longPress];
    
    // 设置导航栏最右侧的按钮
    UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addBtn.frame = CGRectMake(0, 0, 44, 44);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    addBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [addBtn addTarget:self action:@selector(didClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHGoodsShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.isShowDelete = self.isShowDelete;
    cell.model = self.dataArr[indexPath.item];
    __weak typeof(self) weakSelf = self;
    cell.cellItem = indexPath;
    cell.clickDeleteBlock = ^(NSIndexPath *cellItem) {
        
        if (cellItem.section != -1) {
            
            [weakSelf deleteProductWithIndex:cellItem.item];
        } else {
            
            weakSelf.isShowDelete = YES;
            [weakSelf.collectionView reloadData];
        }
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZCHGoodsDetailViewController *VC = [[ZCHGoodsDetailViewController alloc] init];
    VC.productId = ((ZCHGoodsShowModel *)self.dataArr[indexPath.item]).goodsId;
    __weak typeof(self) weakSelf = self;
    VC.backBlock = ^() {
        
        [weakSelf setData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake (0, 0, 50, 0);
}

#pragma mark - 删除商品
- (void)deleteProductWithIndex:(NSInteger)index {
    
    __weak typeof(self) weakSelf = self;
    TTAlertView *alertView = [[TTAlertView alloc] initWithTitle:@"是否删除该商品" message:nil clickedBlock:^(TTAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [weakSelf deleteGoodsWithIndex:index];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    [alertView show];
    
}

- (void)deleteGoodsWithIndex:(NSInteger)index {
    
    ZCHGoodsShowModel *model = self.dataArr[index];
    NSString *defaultApi = [BASEURL stringByAppendingString:@"merchandies/deleteById.do"];
    NSDictionary *paramDic = @{
                               @"id" : model.goodsId,
                               @"companyId" : self.merchantNo
                               };
    [self.view hudShow];
    [NetManager afPostRequest:defaultApi parms:paramDic finished:^(id responseObj) {
        
        [self.view hiddleHud];
        // 1000:成功，1001：失败，1002：商品id为空，2000错误
        if (responseObj) {
            if ([responseObj[@"code"] integerValue] == 1000) {
                
                [self.dataArr removeObjectAtIndex:index];
                [self.view hudShowWithText:@"删除商品成功"];
            } else {
                
                [self.view hudShowWithText:@"删除商品失败"];
            }
            
        }
        [self.collectionView reloadData];
    } failed:^(NSString *errorMsg) {
        
        [self.view hiddleHud];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:errorMsg];
    }];
}


#pragma mark - 添加按钮的点击事件
- (void)didClickAddBtn:(UIButton *)btn {
    
    if ([btn.titleLabel.text isEqualToString:@"添加"]) {
        EditShopDetailVC *VC = [[EditShopDetailVC alloc] init];
        VC.merchantNo = self.merchantNo;
        __weak typeof(self) weakSelf = self;
        VC.finishBlock = ^(){
            
            [weakSelf setData];
        };
        VC.isEditVC = NO;
        [self.navigationController pushViewController:VC animated:YES];
    } else {
        
        [self saveProductOrder];
    }
}

#pragma mark - 保存商品顺序
- (void)saveProductOrder {
    
    NSString *apiStr = [BASEURL stringByAppendingString:@"merchandies/upMerchandiesSort.do"];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.dataArr.count; i ++) {
        ZCHGoodsShowModel *playingCard = self.dataArr[i];
        NSDictionary *dic = @{@"id" : playingCard.goodsId, @"sort" : @(i + 1)};
        [arr addObject:dic];
    }
    
    NSData *jsonDataBase = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStrBase = [[NSString alloc]initWithData:jsonDataBase encoding:NSUTF8StringEncoding];
    
    NSDictionary *param = @{
                            @"merchandiesList" : jsonStrBase
                            };
    [NetManager afPostRequest:apiStr parms:param finished:^(id responseObj) {
        
        if (responseObj && [responseObj[@"code"] integerValue] == 1000) {
            
            [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
            self.isShowDelete = NO;
            [self.collectionView reloadData];
        } else {
            
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"保存失败"];
        }
    } failed:^(NSString *errorMsg) {
        
        [[UIApplication sharedApplication].keyWindow hudShowWithText:NETERROR];
    }];
}



//- (void)didClickIconView:(UIGestureRecognizer *)longPress {

//    if (self.isShowDelete == NO) {
//        
//        self.isShowDelete = YES;
//        [self.collectionView removeGestureRecognizer:self.longPress];
//        [self.collectionView reloadData];
//        return;
//    }
    
    
//    //获取点击在collectionView的坐标
//    CGPoint point=[longPress locationInView:self.collectionView];
//    //从长按开始
//    if (longPress.state == UIGestureRecognizerStateBegan) {
//        
//        NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
//        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
//        //长按手势状态改变
//    } else if(longPress.state==UIGestureRecognizerStateChanged) {
//        [self.collectionView updateInteractiveMovementTargetPosition:point];
//        //长按手势结束
//    } else if (longPress.state==UIGestureRecognizerStateEnded) {
//        
//        [self.collectionView endInteractiveMovement];
//        
//        //其他情况
//    } else {
//        [self.collectionView cancelInteractiveMovement];
//    }
    
//}
//- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
//    /* 两个indexpath参数, 分别代表源位置, 和将要移动的目的位置*/
//    //-1 是为了不让最后一个可以交换位置
////    if (proposedIndexPath.item == (self.dataArr.count - 1)) {
////        //初始位置
////        return originalIndexPath;
////    } else {
////        //-1 是为了不让最后一个可以交换位置
////        if (originalIndexPath.item == (self.dataArr.count - 1)) {
////            return originalIndexPath;
////        }
//        //      移动后的位置
//        return proposedIndexPath;
////    }
//}
//-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    //记录要移动的数据
//    id object= self.dataArr[sourceIndexPath.item];
//    //删除要移动的数据
//    [self.dataArr removeObjectAtIndex:sourceIndexPath.item];
//    //添加新的数据到指定的位置
//    [self.dataArr insertObject:object atIndex:destinationIndexPath.item];
//}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    ZCHGoodsShowModel *playingCard = self.dataArr[fromIndexPath.item];
    
    [self.dataArr removeObjectAtIndex:fromIndexPath.item];
    [self.dataArr insertObject:playingCard atIndex:toIndexPath.item];
}

//- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (self.isShowDelete == NO) {
//        
//        self.isShowDelete = YES;
//        [self.collectionView reloadData];
//        return;
//    }
//}

//- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (self.isShowDelete == NO) {
//
//        self.isShowDelete = YES;
//        [self.collectionView reloadData];
//        return;
//    }
//    
//}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isShowDelete == NO) {
        
        
        [self.addBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.isShowDelete = YES;
        for (int i = 0; i < self.collectionView.visibleCells.count; i ++) {
            
            ZCHGoodsShowCollectionViewCell *cell = (ZCHGoodsShowCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            cell.deleteBtn.hidden = NO;
        }
        
        return YES;
    }
    
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if ([touch.view isKindOfClass:[UICollectionView class]] && self.isShowDelete == NO) {
//        return YES;
//    }
//    if ([touch.view isKindOfClass:[ZCHGoodsShowCollectionViewCell class]] && self.isShowDelete == YES) {
//        return YES;
//    }
//    return YES;
//}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
